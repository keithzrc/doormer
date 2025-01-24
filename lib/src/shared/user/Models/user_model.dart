import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  final UuidValue id;
  final String email;
  final UserType userType; // "candidate" or "employer"
  final String? firstName; // Nullable for employers
  final String? lastName; // Nullable for employers
  final String? companyName; // Nullable for candidates
  final String? nzbn; // Nullable for candidates
  final String? companyType; // Nullable for candidates
  final String? companySize; // Nullable for candidates
  final String? industry; // Nullable for candidates
  final String? oriented; // Nullable for candidates

  UserModel({
    required this.id,
    required this.email,
    required this.userType,
    this.firstName,
    this.lastName,
    this.companyName,
    this.nzbn,
    this.companyType,
    this.companySize,
    this.industry,
    this.oriented,
  });

  // Factory method to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      userType: UserTypeExtension.fromApiString(json[['userType']]),
      firstName: json['firstName'],
      lastName: json['lastName'],
      companyName: json['companyName'],
      nzbn: json['nzbn'],
      companyType: json['companyType'],
      companySize: json['companySize'],
      industry: json['industry'],
      oriented: json['oriented'],
    );
  }

  // Convert to JSON (optional, for requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userType': userType.toApiString(),
      'firstName': firstName,
      'lastName': lastName,
      'companyName': companyName,
      'nzbn': nzbn,
      'companyType': companyType,
      'companySize': companySize,
      'industry': industry,
      'oriented': oriented,
    };
  }
}
