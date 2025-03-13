import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_posting.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_status.dart';
import 'package:uuid/uuid.dart';
import 'package:dartz/dartz.dart';

/// Repository interface for managing job postings.
abstract class JobManagementRepository {
  /// Creates a new job posting.
  Future<Either<Failure, void>> createJob(JobPosting jobPosting);

  /// Updates an existing job posting.
  Future<Either<Failure, void>> updateJob(JobPosting jobPosting);

  /// Deletes a job posting by its ID.
  Future<Either<Failure, void>> deleteJob(UuidValue jobId);

  /// Updates the status of a job (open, closed, on hold).
  Future<Either<Failure, void>> setJobStatus(UuidValue jobId, JobStatus status);

  /// Gets all jobs created by an employer.
  Future<Either<Failure, List<JobPosting>>> getAllJobs(UuidValue employerId);

  /// Gets details of a specific job by ID.
  Future<Either<Failure, JobPosting>> getJobById(UuidValue jobId);

  /// Automatically expires jobs that have reached their expiration date.
  Future<Either<Failure, void>> autoExpireJobs();
}
