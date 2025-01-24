enum UserType { candidate, employer }

extension UserTypeExtension on UserType {
  // Convert `UserType` to API string
  String toApiString() {
    switch (this) {
      case UserType.candidate:
        return 'candidate';
      case UserType.employer:
        return 'employer';
    }
  }

  // Convert API string to `UserType`
  static UserType fromApiString(String userType) {
    switch (userType) {
      case 'candidate':
        return UserType.candidate;
      case 'employer':
        return UserType.employer;
      default:
        throw Exception('Unknown user type: $userType');
    }
  }
}
