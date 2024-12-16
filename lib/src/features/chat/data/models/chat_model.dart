import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';

const String id = 'id';
const String userName = 'userName';

class ContactModel extends Contact {
  static final Logger _logger = Logger();

  ContactModel({
    required super.id,
    required super.userName,
    required super.avatarUrl,
    required super.lastMessage,
    required super.createdTime,
    required super.isArchived,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedTime;
    final createdTime = json['createdTime'];
    try {
      parsedTime = DateTime.parse(createdTime).toLocal();
    } catch (e) {
      parsedTime = null;
      _logger.e("Unable to parse createdTime");
      throw FormatException('Unable to parse createdTime', e);
    }
    _validateRequiredFieldsOrThrow(json);

    const uuid = Uuid();
    return ContactModel(
      id: uuid,
      userName: json[userName] as String,
      avatarUrl: json['avatarUrl'] as String,
      lastMessage: json['lastMessage'] as String,
      createdTime: parsedTime,
      isArchived: json['isArchived'] as bool,
    );
  }
  Map<String, dynamic> toJson() {
    if (createdTime == null) {
      _logger.e("createdTime is null");
      throw const FormatException('Required field createdTime is null');
    }
    return {
      id: id.toString(),
      userName: userName,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage,
      'createdTime': createdTime!.toUtc().toIso8601String(),
      'isArchived': isArchived,
    };
  }

  static void _validateRequiredFieldsOrThrow(Map<String, dynamic> json) {
    final fields = [id, userName, 'avatarUrl', 'lastMessage', 'isArchived'];
    for (final field in fields) {
      if (json[field] == null) {
        throw FormatException('Missing required field: $field');
      }
    }
  }
}
