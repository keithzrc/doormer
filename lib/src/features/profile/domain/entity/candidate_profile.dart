import 'package:doormer/src/features/profile/domain/entity/profile.dart';

class CandidateProfile extends Profile {
  final List<String> expectations; // 1st, 2nd, 3rd choice
  final List<String> companySizes;
  final List<String> cultures;
  final List<String> roles;
  final List<String> industries;
  final String firstName;
  final String lastName;
  final String educationLevel;
  final String university;
  final List<String> skillset;
  final List<String> certifications;
  final String profileAvatar;

  CandidateProfile({
    required super.userId,
    required this.expectations,
    required this.companySizes,
    required this.cultures,
    required this.roles,
    required this.industries,
    required this.firstName,
    required this.lastName,
    required this.educationLevel,
    required this.university,
    required this.skillset,
    required this.certifications,
    required this.profileAvatar,
  });

  /// Returns the number of completed fields vs total fields
  String getCompletionStatus() {
    int totalFields = 12;
    int completedFields = 0;

    if (firstName.isNotEmpty) completedFields++;
    if (lastName.isNotEmpty) completedFields++;
    if (profileAvatar.isNotEmpty) completedFields++;
    if (expectations.isNotEmpty) completedFields++;
    if (companySizes.isNotEmpty) completedFields++;
    if (cultures.isNotEmpty) completedFields++;
    if (roles.isNotEmpty) completedFields++;
    if (industries.isNotEmpty) completedFields++;
    if (educationLevel.isNotEmpty) completedFields++;
    if (university.isNotEmpty) completedFields++;
    if (skillset.isNotEmpty) completedFields++;
    if (certifications.isNotEmpty) completedFields++;

    return "$completedFields/$totalFields";
  }
}
