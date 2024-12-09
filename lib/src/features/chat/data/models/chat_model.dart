import '../../domain/entities/chat_entity.dart';

class ContactModel extends Chat {
  ContactModel({
    required super.id,
    required super.userName,
    required super.avatarUrl,
    required super.lastMessage,
    required super.createdTime, // 改为可空类型以支持无效值
    required super.isArchived,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedTime;
    try {
      // 检查 json['lastMessageTime'] 是否为空并尝试解析
      if (json['lastMessageTime'] != null && json['lastMessageTime'] is String) {
        parsedTime = DateTime.parse(json['lastMessageTime']);
      }
    } catch (e) {
      // 捕获异常并提供默认值（可以是 null 或 DateTime.now()）
      parsedTime = null; // 或者 DateTime.now()
    }

    return ContactModel(
      id: json['id'] ?? '', // 提供默认值以避免空值问题
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
      'createdTime': createdTime?.toLocal().toIso8601String() ?? '', // 如果为空，返回空字符串
      'isArchived': isArchived,
    };
  }
}