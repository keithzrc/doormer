part of 'global_session_bloc.dart';

abstract class GlobalSessionState extends Equatable {
  const GlobalSessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitialState extends GlobalSessionState {}

class SessionActiveState extends GlobalSessionState {
  final User user;

  const SessionActiveState(this.user);

  @override
  List<Object> get props => [user];
}

class SessionExpiredState extends GlobalSessionState {}

class SessionLoadingState extends GlobalSessionState {}
