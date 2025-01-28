import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart'; // Import AccountStatus
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
  final AccountStatus accountStatus; // Added accountStatus

  UserModel({
    required this.id,
    required this.email,
    required this.userType,
    required this.accountStatus, // Required field
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
    AppLogger.info('Parsing UserModel from JSON: $json'); // Log the JSON data

    return UserModel(
      id: UuidValue(json['id']), // This might throw an error if `id` is null
      email: json['email'], // Provide a default value for safety
      userType: UserTypeExtension.fromApiString(json['userType']),
      accountStatus:
          AccountStatusExtension.fromApiString(json['accountStatus']),
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
      'id': id.toString(), // Convert UuidValue to string
      'email': email,
      'userType': userType.toApiString(),
      'accountStatus': accountStatus.toApiString(), // Convert to API string
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
