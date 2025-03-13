import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for retrieving all jobs created by an employer.
class GetAllJobs {
  final JobManagementRepository repository;

  GetAllJobs(this.repository);

  /// Calls the repository to fetch all jobs for an employer.
  Future<Either<Failure, List<JobPosting>>> call(UuidValue employerId) async {
    return repository.getAllJobs(employerId);
  }
}
