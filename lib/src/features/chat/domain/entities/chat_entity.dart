// lib/features/chat/domain/entities/chat.dart
class Chat {
  final String id; 
  final String userName; 
  final String avatarUrl; 
  final String lastMessage; 
  final DateTime lastMessageTime; 
  final bool isArchived; 

  Chat({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isArchived,
  });
}
