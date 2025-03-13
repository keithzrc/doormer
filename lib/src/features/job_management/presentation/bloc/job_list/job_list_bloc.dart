import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/usecase/job_management_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

part 'job_list_event.dart';
part 'job_list_state.dart';

/// Bloc to handle fetching all jobs for an employer.
class JobListBloc extends Bloc<JobListEvent, JobListState> {
  final JobManagementUseCases jobUseCases;

  JobListBloc(this.jobUseCases) : super(JobListInitial()) {
    on<FetchJobs>(_onFetchJobs);
    on<RefreshJobs>(_onRefreshJobs);
  }

  /// Handles fetching all jobs
  Future<void> _onFetchJobs(FetchJobs event, Emitter<JobListState> emit) async {
    emit(JobListLoading());
    final result = await jobUseCases.getAllJobs(event.employerId);
    result.fold(
      (failure) =>
          emit(JobListError("Failed to fetch jobs: ${failure.message}")),
      (jobs) => emit(JobListLoaded(jobs)),
    );
  }

  /// Handles refreshing the job list manually
  Future<void> _onRefreshJobs(
      RefreshJobs event, Emitter<JobListState> emit) async {
    emit(JobListLoading());
    final result = await jobUseCases.getAllJobs(event.employerId);
    result.fold(
      (failure) =>
          emit(JobListError("Failed to refresh jobs: ${failure.message}")),
      (jobs) => emit(JobListLoaded(jobs)),
    );
  }
}
