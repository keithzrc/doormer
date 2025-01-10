import 'dart:async';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/domain/repositories/chatbox_repository.dart';
import '../models/message_model.dart';

/// Implementation of the [ChatboxRepository] interface.
class ChatboxRepositoryImpl implements ChatboxRepository {
  final LocalDataSource _localDataSource;
  final _messageController = StreamController<List<Message>>.broadcast();
  final Completer<void> _dataLoaded = Completer<void>();
  List<ContactModel>? _contacts;

  ChatboxRepositoryImpl({
    required LocalDataSource localDataSource,
  }) : _localDataSource = localDataSource {
    _initializeData();
  }

  /// Initializes data and completes the `_dataLoaded` completer when done.
  void _initializeData() async {
    AppLogger.info('Initializing data in ChatboxRepositoryImpl');
    try {
      _contacts = await _localDataSource.loadDummyData();
      AppLogger.info(
          'Data initialized in ChatboxRepositoryImpl: ${_contacts?.length} contacts loaded');
      _dataLoaded.complete(); // Signal that data is ready
    } catch (error) {
      AppLogger.error(
          'Data initialization failed in ChatboxRepositoryImpl', error);
      _dataLoaded.completeError(error); // Signal failure
    }
  }

  /// Ensures data is loaded before initialization is completed.
  Future<void> _ensureDataLoaded() async {
    if (_contacts == null) {
      AppLogger.info('Loading contacts data...');
      _contacts = await _localDataSource.loadDummyData();
      AppLogger.info('Loaded ${_contacts?.length} contacts');
    }
  }

  /// Finds a contact by their ID.
  ContactModel? _findContactById(String contactId) {
    AppLogger.debug('Finding contact with ID: $contactId');
    
    if (_contacts == null) {
      AppLogger.error('_contacts is null, data not loaded yet');
      return null;
    }

    AppLogger.debug('Available contacts: ${_contacts!.map((c) => '${c.id}: ${c.userName}').join(', ')}');
    
    try {
      final contact = _contacts!.firstWhere(
        (contact) => contact.id.toString() == contactId,
      );
      AppLogger.debug('Found contact: ${contact.userName} with ID: ${contact.id}');
      return contact;
    } catch (e) {
      AppLogger.error('Contact not found for ID: $contactId, Error: $e');
      return null;
    }
  }

  @override
  Future<ContactInfo> getContactInfo(String contactId) async {
    AppLogger.info('Getting contact info for ID: $contactId');
    
    try {
      await _ensureDataLoaded();
      final contact = _findContactById(contactId);
      
      if (contact == null) {
        AppLogger.error('Contact not found for ID: $contactId');
        throw Exception('Contact not found');
      }

      final contactInfo = ContactInfo(
        id: contact.id,
        name: contact.userName,
        avatarUrl: contact.avatarUrl,
        position: 'Software Engineer',
        expectedSalary: '¥15k-20k',
        status: contact.isRead ? 'Active' : 'Away'
      );
      
      AppLogger.info('Successfully created ContactInfo for: ${contactInfo.name} with avatar: ${contactInfo.avatarUrl}');
      return contactInfo;
    } catch (e) {
      AppLogger.error('Error in getContactInfo', e);
      rethrow;
    }
  }

  @override
  Stream<List<Message>> getMessages(String contactId) async* {
    await _ensureDataLoaded();
    final chat = _findChatById(contactId);

    if (chat != null) {
      final messages = <Message>[
        MessageModel(
          id: DateTime.now().toString(),
          content: chat['lastMessage'] as String,
          timestamp: DateTime.parse(chat['createdTime'] as String),
          isFromMe: false,
          type: MessageType.text,
        ).toEntity(),
      ];

      yield messages;
      _messageController.add(messages);
    } else {
      yield [];
    }
  }

  @override
  Future<void> sendMessage(Message message) async {
    await _ensureDataLoaded();
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
          .map((json) => MessageModel.fromJson(json).toEntity())
          .toList();
      _messageController.add(updatedMessages);
    }
  }

  @override
  Future<void> sendFile(String path, MessageType type) async {
    await Future.delayed(const Duration(seconds: 1));

    final message = MessageModel(
      id: DateTime.now().toString(),
      content: path.split('/').last,
      timestamp: DateTime.now(),
      isFromMe: true,
      type: type,
      mediaUrl: 'https://example.com/files/${path.split('/').last}',
    ).toEntity();

    await sendMessage(message);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _ensureDataLoaded();
    final chat = _findChatById(messageId);

    if (chat != null) {
      final messagesList = chat['messages'] as List;
      messagesList.removeWhere((message) => message['id'] == messageId);

      final updatedMessages = messagesList
          .map((json) => MessageModel.fromJson(json).toEntity())
          .toList();
      _messageController.add(updatedMessages);

      AppLogger.info('Message deleted: $messageId');
    } else {
      AppLogger.error('Failed to delete message: Chat not found');
      throw Exception('Chat not found');
    }
  }

  @override
  Future<void> updateMessage(Message message) async {
    await _ensureDataLoaded();
    final chat = _findChatById(message.id);

    if (chat != null) {
      final messagesList = chat['messages'] as List;
      final messageIndex =
          messagesList.indexWhere((m) => m['id'] == message.id);

      if (messageIndex != -1) {
        messagesList[messageIndex] = {
          'id': message.id,
          'content': message.content,
          'timestamp': message.timestamp.toIso8601String(),
          'isFromMe': message.isFromMe,
          'type': message.type.toString().split('.').last,
          if (message.mediaUrl != null) 'mediaUrl': message.mediaUrl,
          if (message.audioDuration != null)
            'audioDuration': message.audioDuration!.inMilliseconds,
        };

        final updatedMessages = messagesList
            .map((json) => MessageModel.fromJson(json).toEntity())
            .toList();
        _messageController.add(updatedMessages);
        AppLogger.info('Message updated: ${message.id}');
      }
    } else {
      AppLogger.error('Failed to update message: Chat not found');
      throw Exception('Chat not found');
    }
  }

  /// Finds a chat by its ID.
  Map<String, dynamic>? _findChatById(String contactId) {
    if (_contacts == null) return null;

    try {
      final contact = _findContactById(contactId);
      if (contact == null) return null;

      return {
        'id': contact.id.toString(),
        'lastMessage': contact.lastMessage,
        'createdTime': contact.lastMessageCreatedTime.toIso8601String(),
        'messages': [],
      };
    } catch (e) {
      AppLogger.error('Error finding chat: $e');
      return null;
    }
  }

  /// Disposes of resources.
  void dispose() {
    _messageController.close();
    AppLogger.info('ChatboxRepositoryImpl disposed');
  }
}
