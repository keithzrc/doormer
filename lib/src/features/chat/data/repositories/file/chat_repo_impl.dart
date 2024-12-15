import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../models/chat_model.dart';

const fileDBPath =
    'lib/src/features/chat/data/repositories/file/dummydata.json';

class ChatRepositoryImpl implements ChatRepository {
  List<ContactModel> _chats = [];
  final Logger _logger = Logger();
  ChatRepositoryImpl() {
    _loadDummyData().then((_) {
      _logger.i('Data initialization completed');
    }).catchError((error) {
      _logger.e('Data initialization failed');
    });
  }

  Future<void> _loadDummyData() async {
    try {
      final String response = await rootBundle.loadString(fileDBPath);
      final List<dynamic> jsonData = json.decode(response);
      if (jsonData.isEmpty) {
        _logger.e('empty jason');
      }
      _chats = jsonData.map((data) => ContactModel.fromJson(data)).toList();
      _logger.i('Dummy data loaded successfully.');
    } catch (e) {
      _logger.e('Error loading dummy data', e);
      rethrow;
    }
  }

  @override
  Future<List<Contact>> getUnarchivechatList() async {
    await _ensureDataLoaded();
    return _chats.where((chat) => !chat.isArchived).toList();
  }

  @override
  Future<List<Contact>> getArchivedList() async {
    await _ensureDataLoaded();
    return _chats.where((chat) => chat.isArchived).toList();
  }

  final int indexNotFound = -1;

  @override
  Future<void> archiveChat(Uuid uuid) async {
    await _ensureDataLoaded();
    final index = _chats.indexWhere((chat) => chat.uuid == uuid);
    if (index != indexNotFound) {
      final chat = _chats[index];
      _chats[index] = _mapToArchivedContact(chat);
      _logger.i('Chat with ID $uuid archived successfully.');
    } else {
      _logger.w('Chat with ID $uuid not found.');
    }
  }

  ContactModel _mapToArchivedContact(Contact chat) {
    return ContactModel(
      uuid: chat.uuid,
      userName: chat.userName,
      avatarUrl: chat.avatarUrl,
      lastMessage: chat.lastMessage,
      createdTime: chat.createdTime,
      isArchived: true,
    );
  }

  @override
  Future<void> deleteChat(Uuid chatId) async {
    await _ensureDataLoaded();

    final initialLength = _chats.length;

    _chats.removeWhere((chat) => chat.uuid == chatId);

    if (_chats.length == initialLength) {
      _logger.w('Chat with ID $chatId not found.');
    } else {
      _logger.i('Chat with ID $chatId successfully removed.');
    }
  }

  Future<void> autoArchiveInactiveChats(Duration threshold) async {
    await _ensureDataLoaded();
    final now = DateTime.now();
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      if (!chat.isArchived &&
          now.difference(chat.createdTime ?? DateTime.now()) > threshold) {
        _chats[i] = ContactModel(
          uuid: chat.uuid,
          userName: chat.userName,
          avatarUrl: chat.avatarUrl,
          lastMessage: chat.lastMessage,
          createdTime: chat.createdTime,
          isArchived: true,
        );
        _logger.i('Chat with ID ${chat.uuid} auto-archived.');
      }
    }
  }

  Future<void> _ensureDataLoaded() async {
    if (_chats.isEmpty) {
      await _loadDummyData();
    }
  }
}
