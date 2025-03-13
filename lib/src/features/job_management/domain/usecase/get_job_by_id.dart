import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for retrieving details of a specific job by its ID.
class GetJobById {
  final JobManagementRepository repository;

  GetJobById(this.repository);

  /// Calls the repository to fetch details of a job.
  Future<Either<Failure, JobPosting>> call(UuidValue jobId) async {
    return repository.getJobById(jobId);
  }
}
