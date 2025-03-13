import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_status.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for updating the job status.
class SetJobStatus {
  final JobManagementRepository repository;

  SetJobStatus(this.repository);

  /// Calls the repository to set the job status.
  Future<Either<Failure, void>> call(UuidValue jobId, JobStatus status) async {
    return repository.setJobStatus(jobId, status);
  }
}
