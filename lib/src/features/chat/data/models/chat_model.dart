import 'package:uuid/uuid.dart'; 
import '../../domain/entities/chat_entity.dart';

class ContactModel extends Chat {
  // ignore: prefer_const_constructors
  static final Uuid _uuid = Uuid(); 

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
    try {
      if (json['lastMessageTime'] != null && json['lastMessageTime'] is String) {
        parsedTime = DateTime.parse(json['lastMessageTime']);
      }
    } catch (e) {
      parsedTime = null; 
    }

    return ContactModel(
      id: json['id'] ?? _uuid.v4(), 
      userName: json['userName'] ?? 'Unknown User',
      avatarUrl: json['avatarUrl'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      createdTime: parsedTime,
      isArchived: json['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'createdTime': createdTime?.toLocal().toIso8601String() ?? '',
      'isArchived': isArchived,
    };
  }
}
