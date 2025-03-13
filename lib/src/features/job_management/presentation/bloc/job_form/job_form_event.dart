part of 'job_form_bloc.dart';

/// Defines all actions that JobFormBloc can handle.
abstract class JobFormEvent extends Equatable {
  const JobFormEvent();

  @override
  List<Object?> get props => [];
}

/// Event for creating a new job posting.
class CreateJob extends JobFormEvent {
  final JobPosting jobPosting;

  const CreateJob(this.jobPosting);

  @override
  List<Object?> get props => [jobPosting];
}

/// Event for updating an existing job.
class UpdateJob extends JobFormEvent {
  final JobPosting jobPosting;

  const UpdateJob(this.jobPosting);

  @override
  List<Object?> get props => [jobPosting];
}

/// Event for deleting a job posting.
class DeleteJob extends JobFormEvent {
  final UuidValue jobId;

  const DeleteJob(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

/// Event for changing the status of a job.
class ChangeJobStatus extends JobFormEvent {
  final UuidValue jobId;
  final JobStatus newStatus;

  const ChangeJobStatus(this.jobId, this.newStatus);

  @override
  List<Object?> get props => [jobId, newStatus];
}
