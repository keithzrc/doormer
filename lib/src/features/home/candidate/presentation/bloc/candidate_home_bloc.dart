import 'package:bloc/bloc.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_data_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/usecase/candidate_home_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'candidate_home_event.dart';
part 'candidate_home_state.dart';

class CandidateHomeBloc extends Bloc<CandidateHomeEvent, CandidateHomeState> {
  final GetHomeData getHomeDataUseCase;

  CandidateHomeBloc({required this.getHomeDataUseCase}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<CandidateHomeState> emit) async {
    emit(HomeLoading());
    final result = await getHomeDataUseCase();
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homeData) => emit(HomeLoaded(homeData: homeData)),
    );
  }

  Future<void> _onRefreshHomeData(
      RefreshHomeData event, Emitter<CandidateHomeState> emit) async {
    emit(HomeLoading());
    final result = await getHomeDataUseCase();
    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homeData) => emit(HomeLoaded(homeData: homeData)),
    );
  }
}
