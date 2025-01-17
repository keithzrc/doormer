part of 'global_session_bloc.dart';

abstract class GlobalSessionEvent extends Equatable {
  const GlobalSessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionExpiredState extends GlobalSessionState {}

class CheckSession extends GlobalSessionEvent {}

class ExpireSession extends GlobalSessionEvent {}

class RefreshSession extends GlobalSessionEvent {}
