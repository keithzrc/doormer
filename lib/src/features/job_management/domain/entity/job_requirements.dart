/// Represents the required qualifications and skills for a job posting.
class JobRequirements {
  /// List of required majors (fields of study) for candidates.
  final List<String> majors;

  /// List of required degrees (e.g., Bachelor's, Master's).
  final List<String> degrees;

  /// Minimum required years of work experience.
  final int minWorkExperience;

  /// List of mandatory skills required for the job.
  final List<String> skillset;

  /// List of required certifications (e.g., PMP, AWS Certified).
  final List<String> certifications;

  /// List of required driving licenses (e.g., Class A, Class B).
  final List<String> drivingLicenses;

  /// List of acceptable visa statuses for candidates.
  final List<String> visaStatuses;

  JobRequirements({
    required this.majors,
    required this.degrees,
    required this.minWorkExperience,
    required this.skillset,
    required this.certifications,
    required this.drivingLicenses,
    required this.visaStatuses,
  });
}
 