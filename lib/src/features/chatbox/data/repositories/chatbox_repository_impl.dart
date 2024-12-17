import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../../domain/repositories/chatbox_repository.dart';
import '../models/message_model.dart';
import '../models/contact_info_model.dart';

class ChatboxRepositoryImpl implements ChatboxRepository {
  Map<String, dynamic>? _dummyData;
  final _messageController = StreamController<List<Message>>.broadcast();
  
  Future<void> _loadDummyData() async {
    if (_dummyData != null) return;
    
    try {
      final jsonString = await rootBundle.loadString(
        'lib/src/features/chat/data/repositories/file/dummydata.json'
      );
      _dummyData = {'chats': json.decode(jsonString)};
    } catch (e) {
      throw Exception('Failed to load chat data: $e');
    }
  }

  Map<String, dynamic>? _findChatById(String contactId) {
    if (_dummyData == null) return null;
    
    final chats = _dummyData!['chats'] as List;
    try {
      return chats.firstWhere(
        (chat) => chat['id'] == contactId,
        orElse: () => null,
      ) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<Message>> getMessages(String contactId) async* {
    await _loadDummyData();
    final chat = _findChatById(contactId);
    
    if (chat != null) {
      final messages = <Message>[
        MessageModel(
          id: DateTime.now().toString(),
          content: chat['lastMessage'] as String,
          timestamp: DateTime.parse(chat['createdTime'] as String),
          isFromMe: false,
          type: MessageType.text,
        ),
      ];
      
      yield messages;
      _messageController.add(messages);
    } else {
      yield [];
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    await _loadDummyData();
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    final chat = _findChatById(message.id);
    if (chat != null) {
      final messagesList = chat['messages'] as List;
      final newMessage = {
        'id': message.id,
        'content': message.content,
        'timestamp': message.timestamp.toIso8601String(),
        'isFromMe': message.isFromMe,
        'type': message.type.toString().split('.').last,
        if (message.mediaUrl != null) 'mediaUrl': message.mediaUrl,
        if (message.audioDuration != null) 
          'audioDuration': message.audioDuration!.inMilliseconds,
      };
      
      messagesList.add(newMessage);
      
      final updatedMessages = messagesList
          .map((json) => MessageModel.fromJson(json))
          .toList();
      _messageController.add(updatedMessages);
    }
  }

  @override
  Future<void> sendFile(String path, MessageType type) async {
    // 模拟文件上传
    await Future.delayed(const Duration(seconds: 1));
    
    final message = MessageModel(
      id: DateTime.now().toString(),
      content: path.split('/').last,
      timestamp: DateTime.now(),
      isFromMe: true,
      type: type,
      mediaUrl: 'https://example.com/files/${path.split('/').last}',
    );
    
    await sendMessage(message);
  }

  @override
  Future<ContactInfo> getContactInfo(String contactId) async {
    await _loadDummyData();
    final chat = _findChatById(contactId);
    
    if (chat != null) {
      return ContactInfoModel(
        id: chat['id'] as String,
        name: chat['userName'] as String,
        avatarUrl: chat['avatarUrl'] as String,
        position: 'User',
        expectedSalary: 'Not specified',
        status: chat['isRead'] ? 'Read' : 'Unread',
      );
    }
    throw Exception('Contact not found');
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    // 实现删除消息的逻辑
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: 实现实际的删除逻辑
  }

  @override
  Future<void> updateMessage(Message message) async {
    // 实现更新消息的逻辑
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: 实现实际的更新逻辑
  }

  void dispose() {
    _messageController.close();
  }
}