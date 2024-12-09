import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  List<ContactModel> _chats = [];

  ChatRepositoryImpl();

  Future<void> _loadDummyData() async {
    try {
      final String response = await rootBundle.loadString(
          'lib/src/features/chat/data/repositories/file/dummydata.json');
      final List<dynamic> jsonData = json.decode(response);
      _chats = jsonData.map((data) => ContactModel.fromJson(data)).toList();
    } catch (e) {
      print('Error loading dummy data: $e');
      _chats = [];
    }
  }

  @override
  Future<List<Chat>> getChatList() async {
    await _ensureDataLoaded();
    return _chats.where((chat) => !chat.isArchived).toList();
  }

  @override
  Future<List<Chat>> getArchivedList() async {
    await _ensureDataLoaded();
    return _chats.where((chat) => chat.isArchived).toList();
  }
  final int indexNotFound = -1;

  @override
Future<void> archiveChat(String chatId) async {
  await _ensureDataLoaded();
  final index = _chats.indexWhere((chat) => chat.id == chatId);
  if (index != indexNotFound) {
    final chat = _chats[index];
    _chats[index] = _mapToArchivedContact(chat); // 调用提取的方法
  }
}

// 提取映射逻辑到一个单独的方法
ContactModel _mapToArchivedContact(Chat chat) {
  return ContactModel(
    id: chat.id,
    userName: chat.userName,
    avatarUrl: chat.avatarUrl,
    lastMessage: chat.lastMessage,
    createdTime: chat.createdTime, // 保持字段一致性
    isArchived: true, // 标记为已归档
  );
}


  @override
Future<void> deleteChat(String chatId) async {
  await _ensureDataLoaded();
  
  // 记录删除前的长度
  final initialLength = _chats.length;

  // 尝试移除匹配的聊天
  _chats.removeWhere((chat) => chat.id == chatId);

  // 验证删除结果
  if (_chats.length == initialLength) {
    // 如果没有删除任何项，记录日志或抛出异常
    print('Chat with ID $chatId not found.'); // 或者根据需求选择抛出异常
    // throw Exception('Chat with ID $chatId not found.');
  } else {
    // 删除成功时记录日志
    print('Chat with ID $chatId successfully removed.');
  }
}


  Future<void> autoArchiveInactiveChats(Duration threshold) async {
    await _ensureDataLoaded();
    final now = DateTime.now();
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      if (!chat.isArchived &&
    now.difference(chat.createdTime ?? DateTime(1970, 1, 1)) > threshold) {
  _chats[i] = ContactModel(
    id: chat.id,
    userName: chat.userName,
    avatarUrl: chat.avatarUrl,
    lastMessage: chat.lastMessage,
    createdTime: chat.createdTime,
    isArchived: true,
  );
}
    }
  }

  Future<void> _ensureDataLoaded() async {
    if (_chats.isEmpty) {
      await _loadDummyData();
    }
  }
}
