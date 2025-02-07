import 'dart:async';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/domain/repositories/chatbox_repository.dart';
import '../models/message_model.dart';
import 'package:uuid/uuid.dart';
import 'package:doormer/src/core/signalr_service.dart';

/// Implementation of the [ChatboxRepository] interface.
class ChatboxRepositoryImpl implements ChatboxRepository {
  final SignalRService _signalRService;
  final _messageControllers = <String, StreamController<List<Message>>>{};
  final _messagesByContact = <String, List<Message>>{};

  ChatboxRepositoryImpl({
    required SignalRService signalRService,
  }) : _signalRService = signalRService;

  /// Gets or creates a StreamController for the given contact ID
  StreamController<List<Message>> _getControllerFor(String contactId) {
    return _messageControllers.putIfAbsent(
      contactId,
      () => StreamController<List<Message>>.broadcast(),
    );
  }

  @override
  Stream<List<Message>> getMessages(String contactId) async* {
    AppLogger.info("Getting messages for contact: $contactId");
    final controller = _getControllerFor(contactId);
    
    try {
      // 获取现有消息列表
      final messages = _messagesByContact[contactId] ?? [];
      AppLogger.info("Current messages in storage: ${messages.length}");
      yield messages;

      // 订阅后续更新
      await for (final updates in controller.stream) {
        AppLogger.info("Received message updates: ${updates.length} messages");
        yield updates;
      }
    } catch (e) {
      AppLogger.error('Error in getMessages stream for contact: $contactId', e);
      yield [];
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    try {
      AppLogger.info("Sending message - Content: ${message.content}, ContactId: ${message.contactId}, IsFromMe: ${message.isFromMe}");
      await _signalRService.sendMessage(message.contactId, message.content);

      // 获取当前消息列表
      final currentMessages = _messagesByContact[message.contactId] ?? [];
      AppLogger.info("Current messages before update: ${currentMessages.length}");
      
      // 创建新的消息列表并添加消息
      final updatedMessages = List<Message>.from(currentMessages)..add(message);
      
      // 更新存储
      _messagesByContact[message.contactId] = updatedMessages;
      
      // 通知监听者
      _getControllerFor(message.contactId).add(updatedMessages);

      AppLogger.info("Message stored and listeners notified - Total messages: ${updatedMessages.length}");
    } catch (e) {
      AppLogger.error("Failed to send message", e);
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  // @override
  // Future<void> sendFile(String path, MessageType type) async {
  //   await Future.delayed(const Duration(seconds: 1));

  //   final message = MessageModel(
  //     id: DateTime.now().toString(),
  //     contactId: 'current_contact_id',
  //     content: path.split('/').last,
  //     timestamp: DateTime.now(),
  //     isFromMe: true,
  //     type: type,
  //     mediaUrl: type != MessageType.text && type != MessageType.emoji
  //         ? 'https://example.com/files/${path.split('/').last}'
  //         : null,
  //     audioDurationMs: type == MessageType.audio || type == MessageType.voice
  //         ? const Duration(seconds: 30).inMilliseconds
  //         : null,
  //   ).toEntity();

  //   await sendMessage(message);
  // }

  @override
  Future<void> updateMessage(Message message) async {
    try {
      final currentMessages = _messagesByContact[message.contactId] ?? [];
      final messageIndex =
          currentMessages.indexWhere((m) => m.id == message.id);

      if (messageIndex != -1) {
        currentMessages[messageIndex] = message;
        _messagesByContact[message.contactId] = currentMessages;

        // 通知监听者消息已更新
        _getControllerFor(message.contactId).add(currentMessages);
        AppLogger.info('Message updated: ${message.id}');
      } else {
        AppLogger.error('Failed to update message: Message not found');
        throw Exception('Message not found');
      }
    } catch (e) {
      AppLogger.error('Failed to update message', e);
      throw Exception('Failed to update message: ${e.toString()}');
    }
  }

  /// Disposes of resources.
  void dispose() {
    for (final controller in _messageControllers.values) {
      controller.close();
    }
    _messageControllers.clear();
    AppLogger.info('ChatboxRepositoryImpl disposed');
  }

  @override
  Future<void> deleteMessage(String messageId) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Future<void> sendFile(String path, MessageType type) {
    // TODO: implement sendFile
    throw UnimplementedError();
  }

   /// 处理接收到的消息
  void handleReceivedMessage(Message message) {
    try {
      AppLogger.info("Handling received message - Message details:");
      AppLogger.info("- Content: ${message.content}");
      AppLogger.info("- IsFromMe: ${message.isFromMe}");
      AppLogger.info("- ContactId: ${message.contactId}");

      // 获取当前消息列表
      final currentMessages = _messagesByContact[message.contactId] ?? [];
      AppLogger.info("Current messages before update: ${currentMessages.length}");
      
      // 检查消息是否已存在
      if (!currentMessages.any((m) => m.id == message.id)) {
        // 创建新的消息列表并添加消息
        final updatedMessages = List<Message>.from(currentMessages)..add(message);
        updatedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        
        // 更新存储
        _messagesByContact[message.contactId] = updatedMessages;
        
        // 通知监听者
        _getControllerFor(message.contactId).add(updatedMessages);
        
        AppLogger.info("Message stored successfully - Total messages: ${updatedMessages.length}");
      } else {
        AppLogger.info("Message already exists, skipping");
      }
    } catch (e) {
      AppLogger.error("Error handling received message", e);
      throw Exception('Failed to handle received message: ${e.toString()}');
    }
  }
}