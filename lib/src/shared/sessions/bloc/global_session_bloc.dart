import 'package:bloc/bloc.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:equatable/equatable.dart';

part 'global_session_event.dart';
part 'global_session_state.dart';

class GlobalSessionBloc extends Bloc<GlobalSessionEvent, GlobalSessionState> {
  final SessionService _sessionService;

  GlobalSessionBloc({required SessionService sessionService})
      : _sessionService = sessionService,
        super(SessionInitialState()) {
    on<CheckSession>(_onCheckSession);
    on<ExpireSession>(_onExpireSession);
    on<RefreshSession>(_onRefreshSession);
    on<SessionStarted>(_onSessionStarted);
  }

  Future<void> _onCheckSession(
    CheckSession event,
    Emitter<GlobalSessionState> emit,
  ) async {
    // TODO: Implementation
  }

  Future<void> _onExpireSession(
    ExpireSession event,
    Emitter<GlobalSessionState> emit,
  ) async {
    emit(SessionExpiredState());
  }

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

  Future<void> _onSessionStarted(
    SessionStarted event, // Fix the event type here
    Emitter<GlobalSessionState> emit,
  ) async {
    emit(SessionActiveState(event.user));
  }
}
