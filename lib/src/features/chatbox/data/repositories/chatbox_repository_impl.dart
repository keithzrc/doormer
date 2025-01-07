import 'dart:async';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../../domain/repositories/chatbox_repository.dart';
import '../models/message_model.dart';
import '../models/contact_info_model.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';

class ChatboxRepositoryImpl implements ChatboxRepository {
  final LocalDataSource _localDataSource;
  final _messageController = StreamController<List<Message>>.broadcast();
  List<ContactModel>? _contacts;

  ChatboxRepositoryImpl({
    required LocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  Future<void> _loadContacts() async {
    if (_contacts != null) return;
    try {
      print('Loading contacts from LocalDataSource...');
      _contacts = await _localDataSource.loadDummyData();
      print('Contacts loaded: ${_contacts?.length} items');
    } catch (e) {
      print('Error loading contacts: $e');
      throw Exception('Failed to load chat data: $e');
    }
  }

  ContactModel? _findContactById(String contactId) {
    if (_contacts == null) return null;
    try {
      print('Searching for contact with ID: $contactId');
      print('Available contacts: ${_contacts!.map((c) => c.id.toString()).join(', ')}');
      
      final contact = _contacts!.firstWhere(
        (contact) {
          print('Comparing ${contact.id.toString()} with $contactId');
          return contact.id.toString() == contactId;
        },
      );
      
      print('Found contact: ${contact.userName}');
      return contact;
    } catch (e) {
      print('Error finding contact: $e');
      return null;
    }
  }

  @override
  Future<ContactInfo> getContactInfo(String contactId) async {
    print('Getting contact info for ID: $contactId');
    await _loadContacts();
    final contact = _findContactById(contactId);
    
    if (contact != null) {
      print('Creating ContactInfo for ${contact.userName}');
      print('Contact ID type: ${contact.id.runtimeType}');
      return ContactInfoModel(
        id: contact.id.toString(),
        name: contact.userName,
        avatarUrl: contact.avatarUrl,
        position: 'Chat User',
        expectedSalary: 'Not Available',
        status: _getContactStatus(contact),
      );
    }
    print('Contact not found for ID: $contactId');
    throw Exception('Contact not found');
  }

  String _getContactStatus(ContactModel contact) {
    if (contact.isArchived) {
      return 'Archived';
    }
    if (!contact.isRead) {
      return 'Unread Messages';
    }
    return 'Active';
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

      final updatedMessages =
          messagesList.map((json) => MessageModel.fromJson(json)).toList();
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

  _findChatById(String contactId) {}
}

class _loadDummyData {}
