import '../../domain/entities/chat_entity.dart';

class ChatModel extends Chat {
  ChatModel({
    required String id,
    required String userName,
    required String avatarUrl,
    required String lastMessage,
    required DateTime lastMessageTime,
    required bool isArchived,
  }) : super(
          id: id,
          userName: userName,
          avatarUrl: avatarUrl,
          lastMessage: lastMessage,
          lastMessageTime: lastMessageTime,
          isArchived: isArchived,
        );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      userName: json['userName'],
      avatarUrl: json['avatarUrl'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      isArchived: json['isArchived'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'isArchived': isArchived,
    };
  }
}
