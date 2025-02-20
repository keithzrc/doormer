import 'package:bloc/bloc.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/shared/user/account_status.dart';
import 'package:doormer/src/shared/user/entities/user_candidate_entity.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'global_session_event.dart';
part 'global_session_state.dart';

// Bloc responsible for managing user session status
class GlobalSessionBloc extends Bloc<GlobalSessionEvent, GlobalSessionState> {
  final SessionService _sessionService;

  GlobalSessionBloc({required SessionService sessionService})
      : _sessionService = sessionService,
        super(SessionInitialState()) {
    on<CheckSession>(_onCheckSession);
    on<ExpireSession>(_onExpireSession);
    on<RefreshSession>(_onRefreshSession);
    on<SessionStarted>(_onSessionStarted);
    on<UserInfoUpdated>(_onUserInfoUpdated);
  }

  /// Handles the CheckSession event.
  Future<void> _onCheckSession(
    CheckSession event,
    Emitter<GlobalSessionState> emit,
  ) async {
    // TODO: Implementation
  }

  /// Handles session expiration by emitting SessionExpiredState.
  Future<void> _onExpireSession(
    ExpireSession event,
    Emitter<GlobalSessionState> emit,
  ) async {
    emit(SessionExpiredState());
  }

  /// Handles session refresh by calling the SessionService.
  Future<void> _onRefreshSession(
    RefreshSession event,
    Emitter<GlobalSessionState> emit,
  ) async {
    try {
      emit(SessionLoadingState());
      await _sessionService.refreshToken();
      emit(SessionActiveState(event.user));
    } catch (e) {
      emit(SessionExpiredState());
    }
  }

  /// Handles session start by emitting SessionActiveState and logging.
  Future<void> _onSessionStarted(
    SessionStarted event, // Fix the event type here
    Emitter<GlobalSessionState> emit,
  ) async {
    emit(SessionActiveState(event.user));
    AppLogger.info('Session Started');
  }

  /// Updates user info during an active session.
  Future<void> _onUserInfoUpdated(
    UserInfoUpdated event,
    Emitter<GlobalSessionState> emit,
  ) async {
    final currentState = state;

    if (currentState is SessionActiveState) {
      // Create a new state with the updated user details
      emit(SessionActiveState(event.updatedUser));
    } else {
      // Handle edge case: User not in an active session
      AppLogger.error(
          'UserInfoUpdated event received without an active session');
    }
  }

  /// Returns the current user if session is active, otherwise expires session.
  User getUser() {
    return Candidate(
      id: UuidValue(
        "7d1277f6-72f2-48ac-9fe5-4ac3903502ee",
      ),
      email: 'candidate@example.com',
      userType: UserType.candidate,
      accountStatus: AccountStatus.active,
      firstName: 'Alice',
      lastName: 'Smith',
      mobileNumber: '+15551234567',
    );
    // TODO: put it back
    // final currentState = state;

    // if (currentState is SessionActiveState) {
    //   return currentState.user;
    // } else {
    //   add(ExpireSession()); // Move the state to SessionExpiredState
    //   throw Exception("User session is expired. Redirecting to login.");
    // }
  }
}
