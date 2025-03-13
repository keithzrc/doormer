import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/usecase/job_management_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'selected_job_event.dart';
part 'selected_job_state.dart';

/// Bloc to handle fetching a single job's details.
class SelectedJobBloc extends Bloc<SelectedJobEvent, SelectedJobState> {
  final JobManagementUseCases jobUseCases;

  SelectedJobBloc(this.jobUseCases) : super(SingleJobInitial()) {
    on<FetchJob>(_onFetchJob);
    on<SetJob>(_onSetJob);
    on<UpdateJobInState>(_onUpdateJobInState);
  }

  /// Handles fetching job details by ID
  Future<void> _onFetchJob(
      FetchJob event, Emitter<SelectedJobState> emit) async {
    emit(SingleJobLoading());
    final result = await jobUseCases.getJobById(event.jobId);
    result.fold(
      (failure) => emit(
          SingleJobError("Failed to fetch job details: ${failure.message}")),
      (job) => emit(SingleJobLoaded(job)),
    );
  }

  /// Handles setting a preloaded job in the state (from JobListBloc).
  void _onSetJob(SetJob event, Emitter<SelectedJobState> emit) {
    emit(SingleJobLoaded(event.job));
  }

  /// Handles updating job details in state without API call
  void _onUpdateJobInState(
      UpdateJobInState event, Emitter<SelectedJobState> emit) {
    if (state is SingleJobLoaded) {
      emit(SingleJobLoaded(event.updatedJob));
    }
  }
}
