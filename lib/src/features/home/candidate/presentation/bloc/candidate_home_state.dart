part of 'candidate_home_bloc.dart';

abstract class CandidateHomeState {}

class HomeInitial extends CandidateHomeState {}

class HomeLoading extends CandidateHomeState {}

class HomeLoaded extends CandidateHomeState {
  final CandidateHomeDataEntity homeData;

  HomeLoaded({required this.homeData});
}

class HomeError extends CandidateHomeState {
  final String message;

  HomeError({required this.message});
}
