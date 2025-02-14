import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/registration/domain/usecase/registration_usecase.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/entities/user_candidate_entity.dart';
import 'package:doormer/src/shared/user/entities/user_employer_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationUsecase registrationUsecase;
  final GlobalSessionBloc globalSessionBloc;

  RegistrationBloc(
      {required this.registrationUsecase, required this.globalSessionBloc})
      : super(RegistrationInitial()) {
    on<SubmitCompanyInfoRequested>(_onSubmitCompanyProfile);
    on<SubmitCandidateInfoRequested>(_onSubmitCandidateProfile);
  }

  Future<void> _onSubmitCompanyProfile(
    SubmitCompanyInfoRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    try {
      final currentState = globalSessionBloc.state;
      if (currentState is! SessionActiveState) {
        emit(RegistrationFailure('User session is not active.'));
        return;
      }
      // Retrieve currentUser info
      final currentUser = currentState.user;

      // Register company information called
      await registrationUsecase.registerCompanyInfo(
        companyName: event.companyName,
        nzbn: event.nzbn,
        companyType: event.companyType,
        companySize: event.companySize,
        industry: event.industry,
        oriented: event.companyOrientation,
        companyDescription: event.companyDescription,
        contactFirstName: event.contactFirstName,
        contactLastName: event.contactLastName,
        contactPhoneNumber: event.contactPhoneNumber,
      );

      AppLogger.info('Company registered successfully');

      // Create updated user object
      final updatedUser = Employer(
        id: currentUser.id,
        email: currentUser.email,
        userType: currentUser.userType,
        accountStatus: currentUser.accountStatus,
        companyName: event.companyName,
        nzbn: event.nzbn,
        companyType: event.companyType,
        companySize: event.companySize,
        industry: event.industry,
        oriented: event.companyOrientation,
        companyDescription: event.companyDescription,
        contactFirstName: event.contactFirstName,
        contactLastName: event.contactLastName,
        contactPhoneNumber: event.contactPhoneNumber,
      );
      // Dispatch UserInfoUpdated to update user in GlobalSessionBloc
      globalSessionBloc.add(UserInfoUpdated(updatedUser));

      emit(CompanyRegistrationSuccess());
    } catch (e, stackTrace) {
      emit(RegistrationFailure(e.toString()));
      AppLogger.error(
          'RegistrationFailure state emitted for Company Info Registration',
          e,
          stackTrace);
    }
  }

  Future<void> _onSubmitCandidateProfile(
    SubmitCandidateInfoRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    try {
      AppLogger.info('Sending $event');
      final currentState = globalSessionBloc.state;
      if (currentState is! SessionActiveState) {
        emit(RegistrationFailure('User session is not active.'));
        return;
      }
      final currentUser = currentState.user;
      await registrationUsecase.registerCandidateInfo(
          firstName: event.firstName,
          lastName: event.lastName,
          mobileNumber: event.mobileNumber);
      final updatedUser = Candidate(
        id: currentUser.id,
        email: currentUser.email,
        userType: currentUser.userType,
        accountStatus: currentUser.accountStatus,
        firstName: event.firstName,
        lastName: event.lastName,
        mobileNumber: event.mobileNumber,
      );

      // Dispatch UserInfoUpdated to update user in GlobalSessionBloc
      globalSessionBloc.add(UserInfoUpdated(updatedUser));

      emit(CandidateRegistrationSuccess());
    } catch (e, stackTrace) {
      emit(RegistrationFailure(e.toString()));
      AppLogger.error(
          'RegistrationFailure state emitted for Candidate Info Registration',
          e,
          stackTrace);
    }
  }
}
