import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';

/// Use case for automatically expiring jobs that have reached their expiration date.
class AutoExpireJobs {
  final JobManagementRepository repository;

  AutoExpireJobs(this.repository);

  /// Calls the repository to expire outdated jobs.
  Future<Either<Failure, void>> call() async {
    return repository.autoExpireJobs();
  }
}
