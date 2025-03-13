part of 'selected_job_bloc.dart';

/// Defines all actions that SelectedJobBloc can handle.
abstract class SelectedJobEvent extends Equatable {
  const SelectedJobEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch job details by job ID.
class FetchJob extends SelectedJobEvent {
  final UuidValue jobId;

  const FetchJob(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

/// Event to set the job in state without API call (from JobListBloc).
class SetJob extends SelectedJobEvent {
  final JobPosting job;

  const SetJob(this.job);

  @override
  List<Object?> get props => [job];
}

/// Event to update job details in state without API call.
/// Used when JobFormBloc modifies a job.
class UpdateJobInState extends SelectedJobEvent {
  final JobPosting updatedJob;

  const UpdateJobInState(this.updatedJob);

  @override
  List<Object?> get props => [updatedJob];
}
