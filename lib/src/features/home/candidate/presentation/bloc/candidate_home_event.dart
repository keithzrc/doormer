part of 'candidate_home_bloc.dart';

abstract class CandidateHomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHomeData extends CandidateHomeEvent {
  final UuidValue userId;

  LoadHomeData({required this.userId});

  @override
  List<Object> get props => [userId];
}

class RefreshHomeData extends CandidateHomeEvent {
  final UuidValue userId;

  RefreshHomeData({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CompanyTapped extends CandidateHomeEvent {
  final UuidValue companyId;

  CompanyTapped(this.companyId);

  @override
  List<Object> get props => [companyId];
}
