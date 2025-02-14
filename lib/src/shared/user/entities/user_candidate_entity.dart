import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/account_status.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

// TODO: @Freezed
class Candidate extends User {
  final String firstName;
  final String lastName;
  final String mobileNumber;

  Candidate(
      {required UuidValue id,
      required String email,
      required UserType userType,
      required AccountStatus accountStatus,
      required this.firstName,
      required this.lastName,
      required this.mobileNumber})
      : super(
            id: id,
            email: email,
            userType: userType,
            accountStatus: accountStatus);

  @override
  Candidate copyWith({
    UuidValue? id,
    String? email,
    UserType? userType,
    AccountStatus? accountStatus,
    String? firstName,
    String? lastName,
    String? mobileNumber,
  }) {
    return Candidate(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      accountStatus: accountStatus ?? this.accountStatus,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}
