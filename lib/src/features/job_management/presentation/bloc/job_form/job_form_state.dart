part of 'job_form_bloc.dart';

/// Represents different states for JobFormBloc.
abstract class JobFormState extends Equatable {
  const JobFormState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action happens.
class JobFormInitial extends JobFormState {}

/// State when job form is being submitted (loading state).
class JobFormSubmitting extends JobFormState {}

/// State when a job is successfully created, updated, deleted, or status changed.
class JobFormSuccess extends JobFormState {}

/// State when an error occurs during job creation, update, or deletion.
class JobFormError extends JobFormState {
  final String message;

  const JobFormError(this.message);

  @override
  List<Object?> get props => [message];
}
