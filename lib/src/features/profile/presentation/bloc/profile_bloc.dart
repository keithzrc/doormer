import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/profile/domain/entity/profile.dart';
import 'package:doormer/src/features/profile/domain/usecase/profile_usecase.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCases profileUseCase;
  final GlobalSessionBloc globalSessionBloc;

  ProfileBloc({required this.profileUseCase, required this.globalSessionBloc})
      : super(ProfileInitial()) {
    on<FetchProfileWithOptions>(_onFetchProfileWithOptions);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onFetchProfileWithOptions(
      FetchProfileWithOptions event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = globalSessionBloc.getUser();
      final results = await Future.wait([
        profileUseCase.getUserProfile(user.id),
        profileUseCase.loadProfileOptions(), // Local JSON file
      ]);

      final Either<Failure, Profile> profileResult =
          results[0] as Either<Failure, Profile>;
      final Either<Failure, Map<String, dynamic>> optionsResult =
          results[1] as Either<Failure, Map<String, dynamic>>;

      profileResult.fold(
        (failure) => emit(ProfileError(message: failure.toString())),
        (profile) {
          optionsResult.fold(
            (failure) => emit(ProfileError(message: failure.toString())),
            (options) =>
                emit(ProfileLoaded(profile: profile, options: options)),
          );
        },
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = globalSessionBloc.getUser();
      final Either<Failure, void> result =
          await profileUseCase.updateUserProfile(user.id, event.profile);

      result.fold(
        (failure) => emit(ProfileError(message: failure.toString())),
        (_) => add(FetchProfileWithOptions(userId: user.id)),
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
