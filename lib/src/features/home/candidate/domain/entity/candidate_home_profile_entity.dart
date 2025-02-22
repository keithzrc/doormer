// lib/features/home/domain/entities/candidate_home_profile.dart
class CandidateHomeProfile {
  final String firstName;
  final String lastName;
  final String profileAvatarUrl;

  CandidateHomeProfile({
    required this.firstName,
    required this.lastName,
    required this.profileAvatarUrl,
  });

  String get fullName => '$firstName $lastName';
}
