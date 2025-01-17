// lib/features/auth/domain/entities/user.dart

class User {
  final String id;
  final String email;
  final String? name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}
