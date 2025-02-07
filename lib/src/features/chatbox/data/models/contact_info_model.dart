import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:uuid/uuid.dart';

part 'contact_info_model.g.dart';

@JsonSerializable()
class ContactInfoModel {
  @UuidValueConverter()
  final UuidValue id;
  final String name;
  final String avatarUrl;
  final String position;
  final String expectedSalary;
  final String status;

  ContactInfoModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.position,
    required this.expectedSalary,
    required this.status,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoModelToJson(this);

  ContactInfo toEntity() => ContactInfo(
        id: id,
        name: name,
        avatarUrl: avatarUrl,
        position: position,
        expectedSalary: expectedSalary,
        status: status,
      );

  @override
  String toString() => 'ContactInfoModel('
      'id: $id, '
      'name: $name, '
      'avatarUrl: $avatarUrl, '
      'position: $position, '
      'expectedSalary: $expectedSalary, '
      'status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactInfoModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          position == other.position &&
          expectedSalary == other.expectedSalary &&
          status == other.status;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        name,
        avatarUrl,
        position,
        expectedSalary,
        status,
      );
}
