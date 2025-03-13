import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';

/// Use case for updating an existing job posting.
class UpdateJobPosting {
  final JobManagementRepository repository;

  UpdateJobPosting(this.repository);

  /// Calls the repository to update a job posting.
  Future<Either<Failure, void>> call(JobPosting jobPosting) async {
    return repository.updateJob(jobPosting);
  }
}
