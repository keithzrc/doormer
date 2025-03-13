import 'package:doormer/src/features/job_management/domain/usecase/job_management_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_status.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'job_form_event.dart';
part 'job_form_state.dart';

/// Bloc to handle job creation, updating, deletion, and status changes.
class JobFormBloc extends Bloc<JobFormEvent, JobFormState> {
  final JobManagementUseCases jobUseCases;

  JobFormBloc(this.jobUseCases) : super(JobFormInitial()) {
    on<CreateJob>(_onCreateJob);
    on<UpdateJob>(_onUpdateJob);
    on<DeleteJob>(_onDeleteJob);
    on<ChangeJobStatus>(_onChangeJobStatus);
  }

  /// Handles job creation
  Future<void> _onCreateJob(CreateJob event, Emitter<JobFormState> emit) async {
    emit(JobFormSubmitting());
    final result = await jobUseCases.createJobPosting(event.jobPosting);
    result.fold(
      (failure) =>
          emit(JobFormError("Failed to create job: ${failure.message}")),
      (_) => emit(JobFormSuccess()),
    );
  }

  /// Handles job updating
  Future<void> _onUpdateJob(UpdateJob event, Emitter<JobFormState> emit) async {
    emit(JobFormSubmitting());
    final result = await jobUseCases.updateJobPosting(event.jobPosting);
    result.fold(
      (failure) =>
          emit(JobFormError("Failed to update job: ${failure.message}")),
      (_) => emit(JobFormSuccess()),
    );
  }

  /// Handles job deletion
  Future<void> _onDeleteJob(DeleteJob event, Emitter<JobFormState> emit) async {
    emit(JobFormSubmitting());
    final result = await jobUseCases.deleteJobPosting(event.jobId);
    result.fold(
      (failure) =>
          emit(JobFormError("Failed to delete job: ${failure.message}")),
      (_) => emit(JobFormSuccess()),
    );
  }

  /// Handles job status change
  Future<void> _onChangeJobStatus(
      ChangeJobStatus event, Emitter<JobFormState> emit) async {
    emit(JobFormSubmitting());
    final result = await jobUseCases.setJobStatus(event.jobId, event.newStatus);
    result.fold(
      (failure) =>
          emit(JobFormError("Failed to change job status: ${failure.message}")),
      (_) => emit(JobFormSuccess()),
    );
  }
}
