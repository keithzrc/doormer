part of 'job_list_bloc.dart';

/// Represents different states for JobListBloc.
abstract class JobListState extends Equatable {
  const JobListState();

  @override
  List<Object?> get props => [];
}

/// Initial state before fetching jobs.
class JobListInitial extends JobListState {}

/// State when jobs are being fetched from API.
class JobListLoading extends JobListState {}

/// State when jobs are successfully fetched.
class JobListLoaded extends JobListState {
  final List<JobPosting> jobs;

  const JobListLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

/// State when fetching jobs fails.
class JobListError extends JobListState {
  final String message;

  const JobListError(this.message);

  @override
  List<Object?> get props => [message];
}
