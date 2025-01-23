import 'package:doormer/src/shared/user/company/company.dart';

class EmployerModel {
  final String id;
  final String email;
  final String companyName;
  final String industry;
  final String nzbn;
  final String address;
  final String verifiedStatus; // ACTIVE, PENDING_VERIFICATION, INACTIVE

  EmployerModel({
    required this.id,
    required this.email,
    required this.companyName,
    required this.industry,
    required this.nzbn,
    required this.address,
    required this.verifiedStatus,
  });

  // From JSON to CompanyModel
  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      id: json['id'],
      email: json['email'],
      companyName: json['companyName'],
      industry: json['industry'],
      nzbn: json['nzbn'],
      address: json['address'],
      verifiedStatus: json['verifiedStatus'],
    );
  }

  // From CompanyModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'companyName': companyName,
      'industry': industry,
      'nzbn': nzbn,
      'address': address,
      'verifiedStatus': verifiedStatus,
    };
  }

  // From CompanyEntity to CompanyModel
  factory EmployerModel.fromEntity(EmployerUser entity) {
    return EmployerModel(
      id: entity.id,
      email: entity.email,
      companyName: entity.companyName,
      industry: entity.industry,
      nzbn: entity.nzbn,
      address: entity.address,
      verifiedStatus: entity.verifiedStatus,
    );
  }

  // From CompanyModel to CompanyEntity
  EmployerUser toEntity() {
    return EmployerUser(
      id: id,
      email: email,
      companyName: companyName,
      industry: industry,
      nzbn: nzbn,
      address: address,
      verifiedStatus: verifiedStatus,
    );
  }
}
