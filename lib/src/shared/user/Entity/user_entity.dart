import 'package:doormer/src/shared/user/user_type.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:uuid/uuid.dart';

// TODO: Use freezed once User Entity is finalized
class User {
  final UuidValue id;
  final String email;
  final UserType userType;
  final AccountStatus accountStatus;

  User({
    required this.id,
    required this.email,
    required this.userType,
    required this.accountStatus,
  });
}
