import 'dart:convert';

import 'package:doormer/src/shared/domain/entities/user.dart';
import 'package:doormer/src/core/utils/app_logger.dart';

class UserModel {
  final String accessToken;
  final String refreshToken;
  final UserInfo userInfo; // Nested user info object

  UserModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info('Parsing UserModel from JSON');

    try {
      // Handle userInfo as either a Map or a String
      final userInfoRaw = json['userInfo'];
      final userInfoMap = userInfoRaw is String
          ? jsonDecode(userInfoRaw)
              as Map<String, dynamic> // Convert string to Map
          : userInfoRaw
              as Map<String, dynamic>; // Use directly if already a Map

      return UserModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        userInfo: UserInfo.fromJson(userInfoMap),
      );
    } catch (e, stacktrace) {
      AppLogger.error('Error parsing UserModel: $e\n$stacktrace');
      throw Exception('Invalid JSON structure in UserModel.fromJson');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userInfo': userInfo.toEntity(),
    };
  }
}

class UserInfo extends User {

  UserInfo({
    required super.id,
    required super.email,
    required String super.name,
  });

  // Parse UserInfo from JSON
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    AppLogger.info('Passing UserModel from Json');
    return UserInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  // Convert UserInfo to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Map to User entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }
}
