import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

part 'contact_info_model.g.dart';

final _log = Logger('ContactInfoModel');

/// Data model representing contact information in the data layer.
///
/// This class is used for:
/// - Converting JSON data to ContactInfo entity
/// - Converting ContactInfo entity to JSON data
@JsonSerializable()
class ContactInfoModel extends ContactInfo {
  /// Constructor for [ContactInfoModel].
  ContactInfoModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.position,
    required super.expectedSalary,
    required super.status,
  });

  /// Creates a [ContactInfoModel] instance from JSON data.
  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    _log.fine('Creating ContactInfoModel from JSON: $json');
    return _$ContactInfoModelFromJson(json);
  }

  /// Converts this model instance to JSON data.
  Map<String, dynamic> toJson() {
    final json = _$ContactInfoModelToJson(this);
    _log.fine('Converting ContactInfoModel to JSON: $json');
    return json;
  }

  @override
  String toString() => 'ContactInfoModel('
      'id: $id, '
      'name: $name, '
      'avatarUrl: $avatarUrl, '
      'position: $position, '
      'expectedSalary: $expectedSalary, '
      'status: $status)';
}
