import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart'; // Import AccountStatus
import 'package:uuid/uuid.dart';

class UserModel {
  final UuidValue id;
  final String email;
  final UserType userType; // "candidate" or "employer"
  final AccountStatus accountStatus; // Added accountStatus
  final String? firstName; // Nullable for employers
  final String? mobileNumber;
  final String? lastName; // Nullable for employers
  final String? companyName; // Nullable for candidates
  final String? nzbn; // Nullable for candidates
  final String? companyType; // Nullable for candidates
  final String? companySize; // Nullable for candidates
  final String? industry; // Nullable for candidates
  final String? oriented; // Nullable for candidates
  final String? companyDescription;
  final String? contactFirstName;
  final String? contactLastName;
  final String? contactPhoneNumber;

  UserModel(
      {required this.id,
      required this.email,
      required this.userType,
      required this.accountStatus, // Required field
      this.firstName,
      this.lastName,
      this.mobileNumber,
      this.companyName,
      this.nzbn,
      this.companyType,
      this.companySize,
      this.industry,
      this.oriented,
      this.companyDescription,
      this.contactFirstName,
      this.contactLastName,
      this.contactPhoneNumber});

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
        companyDescription: json['companyDescription'],
        contactFirstName: json['contactFirstName'],
        contactLastName: json['contactLastName'],
        contactPhoneNumber: json['contactPhoneNumber']);
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
      'companyDescription': companyDescription,
      'contactFirstName': contactFirstName,
      'contactLastName': contactLastName,
      'contactPhoneNumber': contactPhoneNumber
    };
  }
}
