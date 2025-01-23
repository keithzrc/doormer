part of 'global_session_bloc.dart';

abstract class GlobalSessionState extends Equatable {
  const GlobalSessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitialState extends GlobalSessionState {}

class SessionActiveState extends GlobalSessionState {}

class SessionExpiredState extends GlobalSessionState {}

class SessionLoadingState extends GlobalSessionState {}
