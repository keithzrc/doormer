import 'package:doormer/src/shared/user/candidate/user.dart';
import 'package:uuid/uuid.dart';

// TODO: Use JsonSerializable once UserModel is finalized in backend
class UserModel {
  final UuidValue id;
  final String email;
  final String? name;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
  });

  /// Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as UuidValue,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  /// Converts the UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  /// Converts a UserModel to a UserEntity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
    );
  }

  /// Creates a UserModel from a UserEntity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
    );
  }
}
