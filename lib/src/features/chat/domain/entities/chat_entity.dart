class Chat {
  final String id; 
  final String userName; 
  final String avatarUrl; 
  final String lastMessage; 
  final DateTime? createdTime; // 改为可空类型
  final bool isArchived; 

  Chat({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.createdTime, // 改为可空类型
    required this.isArchived,
  });
}
