import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';

class ContactInfoModel extends ContactInfo {
  ContactInfoModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.position,
    required super.expectedSalary,
    required super.status,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      position: json['position'] as String,
      expectedSalary: json['expectedSalary'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'position': position,
      'expectedSalary': expectedSalary,
      'status': status,
    };
  }
}
