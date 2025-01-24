import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

// TODO: @Freezed
class Candidate extends User {
  final String firstName;
  final String lastName;

  Candidate({
    required UuidValue id,
    required String email,
    required UserType userType,
    required this.firstName,
    required this.lastName,
  }) : super(id: id, email: email, userType: userType);

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'],
      email: json['email'],
      userType: UserTypeExtension.fromApiString(json['userType']),
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
