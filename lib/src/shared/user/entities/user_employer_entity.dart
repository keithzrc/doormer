import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/account_status.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

//TODO: @freezed
class Employer extends User {
  final String companyName;
  final String nzbn;
  final String companyType;
  final String companySize;
  final String industry;
  final String oriented;
  final String companyDescription;
  final String contactPhoneNumber;
  final String contactFirstName;
  final String contactLastName;

  Employer({
    required UuidValue id,
    required String email,
    required UserType userType,
    required AccountStatus accountStatus,
    required this.companyName,
    required this.nzbn,
    required this.companyType,
    required this.companySize,
    required this.industry,
    required this.oriented,
    required this.companyDescription,
    required this.contactPhoneNumber,
    required this.contactFirstName,
    required this.contactLastName,
  }) : super(
          id: id,
          email: email,
          userType: userType,
          accountStatus: accountStatus,
        );

  /// Creates a new Employer entity with updated values
  @override
  Employer copyWith({
    UuidValue? id,
    String? email,
    UserType? userType,
    AccountStatus? accountStatus,
    String? companyName,
    String? nzbn,
    String? companyType,
    String? companySize,
    String? industry,
    String? oriented,
    String? companyDescription,
    String? contactPhoneNumber,
    String? contactFirstName,
    String? contactLastName,
  }) {
    return Employer(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      accountStatus: accountStatus ?? this.accountStatus,
      companyName: companyName ?? this.companyName,
      nzbn: nzbn ?? this.nzbn,
      companyType: companyType ?? this.companyType,
      companySize: companySize ?? this.companySize,
      industry: industry ?? this.industry,
      oriented: oriented ?? this.oriented,
      companyDescription: companyDescription ?? this.companyDescription,
      contactPhoneNumber: contactPhoneNumber ?? this.contactPhoneNumber,
      contactFirstName: contactFirstName ?? this.contactFirstName,
      contactLastName: contactLastName ?? this.contactLastName,
    );
  }
}
