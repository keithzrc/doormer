// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactInfoModel _$ContactInfoModelFromJson(Map<String, dynamic> json) =>
    ContactInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      position: json['position'] as String,
      expectedSalary: json['expectedSalary'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ContactInfoModelToJson(ContactInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'position': instance.position,
      'expectedSalary': instance.expectedSalary,
      'status': instance.status,
    };
