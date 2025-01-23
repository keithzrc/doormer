import 'package:uuid/uuid.dart';

// TODO: Use freezed once User Entity is finalized
class User {
  final UuidValue id;
  final String email;
  final String? name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}
