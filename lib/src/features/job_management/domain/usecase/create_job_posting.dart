import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';

/// Use case for creating a new job posting.
class CreateJobPosting {
  final JobManagementRepository repository;

  CreateJobPosting(this.repository);

  /// Calls the repository to create a job posting.
  Future<Either<Failure, void>> call(JobPosting jobPosting) async {
    return repository.createJob(jobPosting);
  }
}
