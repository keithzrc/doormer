import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

// TODO: Use freezed once User Entity is finalized
class User {
  final UuidValue id;
  final String email;
  final UserType userType;

  User({
    required this.id,
    required this.email,
    required this.userType,
  });
}
