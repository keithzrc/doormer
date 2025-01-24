import 'package:doormer/src/shared/user/Entity/user_entity.dart';
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

  Employer({
    required UuidValue id,
    required String email,
    required UserType userType,
    required this.companyName,
    required this.nzbn,
    required this.companyType,
    required this.companySize,
    required this.industry,
    required this.oriented,
  }) : super(id: id, email: email, userType: userType);

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      id: json['id'],
      email: json['email'],
      userType: UserTypeExtension.fromApiString(json['userType']),
      companyName: json['companyName'],
      nzbn: json['nzbn'],
      companyType: json['companyType'],
      companySize: json['companySize'],
      industry: json['industry'],
      oriented: json['oriented'],
    );
  }
}
