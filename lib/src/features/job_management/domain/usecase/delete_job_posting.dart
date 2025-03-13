import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for deleting a job posting.
class DeleteJobPosting {
  final JobManagementRepository repository;

  DeleteJobPosting(this.repository);

  /// Calls the repository to delete a job by its ID.
  Future<Either<Failure, void>> call(UuidValue jobId) async {
    return repository.deleteJob(jobId);
  }
}
