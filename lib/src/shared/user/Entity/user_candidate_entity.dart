import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
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
    required AccountStatus accountStatus,
    required this.firstName,
    required this.lastName,
  }) : super(
            id: id,
            email: email,
            userType: userType,
            accountStatus: accountStatus);
}
