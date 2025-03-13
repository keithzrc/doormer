part of 'job_list_bloc.dart';

/// Defines all actions that JobListBloc can handle.
abstract class JobListEvent extends Equatable {
  const JobListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all jobs for an employer.
class FetchJobs extends JobListEvent {
  final UuidValue employerId;

  const FetchJobs(this.employerId);

  @override
  List<Object?> get props => [employerId];
}

/// Event to refresh the job list manually.
class RefreshJobs extends JobListEvent {
  final UuidValue employerId;

  const RefreshJobs(this.employerId);

  @override
  List<Object?> get props => [employerId];
}
