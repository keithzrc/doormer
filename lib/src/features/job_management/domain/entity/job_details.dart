

import 'package:doormer/src/features/job_management/domain/entity/work_type.dart';

/// Contains general details about a job posting.
class JobDetails {
  /// The work type (remote, hybrid, onsite).
  final WorkType workType;

  /// The job location (e.g., city, country).
  final String location;

  /// The date when the job is expected to start.
  final DateTime startingDate;

  /// The job role or position title.
  final String role;

  /// A detailed description of the job, including responsibilities.
  final String jobDescription;

  JobDetails({
    required this.workType,
    required this.location,
    required this.startingDate,
    required this.role,
    required this.jobDescription,
  });
}
