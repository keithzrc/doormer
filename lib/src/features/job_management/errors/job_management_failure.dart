import 'package:doormer/src/core/errors/failure.dart';

/// Job Management-Specific Failures
abstract class JobFailure extends Failure {
  JobFailure(super.message);
}

/// Failure when a job creation request is invalid (e.g., missing required fields)
class JobCreationFailure extends JobFailure {
  JobCreationFailure()
      : super("Failed to create job. Missing or invalid fields.");
}

/// Failure when updating a job posting fails
class JobUpdateFailure extends JobFailure {
  JobUpdateFailure() : super("Failed to update job posting.");
}

/// Failure when deleting a job posting fails
class JobDeletionFailure extends JobFailure {
  JobDeletionFailure() : super("Failed to delete job posting.");
}

/// Failure when updating job status fails
class JobStatusUpdateFailure extends JobFailure {
  JobStatusUpdateFailure() : super("Failed to update job status.");
}

/// Failure when trying to fetch jobs
class JobFetchFailure extends JobFailure {
  JobFetchFailure() : super("Failed to retrieve job postings.");
}

/// Failure when job expiration automation fails
class JobAutoExpireFailure extends JobFailure {
  JobAutoExpireFailure() : super("Failed to auto-expire jobs.");
}
