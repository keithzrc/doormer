part of 'selected_job_bloc.dart';

/// Represents different states for SelectedJobBloc.
abstract class SelectedJobState extends Equatable {
  const SelectedJobState();

  @override
  List<Object?> get props => [];
}

/// Initial state before fetching job details.
class SingleJobInitial extends SelectedJobState {}

/// State when job details are being fetched.
class SingleJobLoading extends SelectedJobState {}

/// State when job details are successfully fetched.
class SingleJobLoaded extends SelectedJobState {
  final JobPosting job;

  const SingleJobLoaded(this.job);

  @override
  List<Object?> get props => [job];
}

/// State when fetching job details fails.
class SingleJobError extends SelectedJobState {
  final String message;

  const SingleJobError(this.message);

  @override
  List<Object?> get props => [message];
}
