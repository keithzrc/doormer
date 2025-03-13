import 'package:doormer/src/features/job_management/domain/entity/job_details.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_preferences.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_requirements.dart';
import 'package:doormer/src/features/job_management/domain/entity/job_status.dart';
import 'package:uuid/uuid.dart';


/// Represents a job posting created by an employer.
class JobPosting {
  /// Unique identifier for the job posting.
  final UuidValue id;

  /// ID of the employer who created this job posting.
  final UuidValue employerId;

  /// The current status of the job (open, closed, on hold).
  final JobStatus status;

  /// The date and time when the job was created.
  final DateTime createdAt;

  /// The expiration date of the job posting (optional).
  /// If `null`, the job does not expire automatically.
  final DateTime? expiresAt;

  /// Basic job information such as title, location, and description.
  final JobDetails details;

  /// The required qualifications for candidates.
  final JobRequirements requirements;

  /// Preferences for candidate traits (e.g., personality, leadership style).
  final JobPreferences preferences;

  JobPosting({
    required this.id,
    required this.employerId,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    required this.details,
    required this.requirements,
    required this.preferences,
  });
}
