import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:doormer/src/features/chat/data/models/chat_model.dart';

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
        _logger.e('empty json');
      }
      _chats = jsonData.map((data) => ContactModel.fromJson(data)).toList();
      _logger.i('Dummy data loaded successfully.');
    } catch (e) {
      _logger.e('Error loading dummy data', e);
      rethrow;
    }
  }

  @override
  Future<List<Contact>> getUnarchivedchatList() async {
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
  Future<void> toggleChat(String chatId) async {
    await _ensureDataLoaded();
    final index = _chats.indexWhere((chat) => chat.id.toString() == chatId);
    if (index != indexNotFound) {
      final chat = _chats[index];
      if (chat.isArchived) {
        _chats[index] = _mapToUnarchivedContact(chat);
        _logger.i('Chat with ID $id unarchived successfully.');
      } else {
        _chats[index] = _mapToArchivedContact(chat);
        _logger.i('Chat with ID $id archived successfully.');
      }
    } else {
      _logger.w('Chat with ID $id not found.');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _ensureDataLoaded();
    final initialLength = _chats.length;
    _chats.removeWhere((chat) => chat.id.toString() == chatId);

    if (_chats.length == initialLength) {
      _logger.w('Chat with ID $chatId not found.');
    } else {
      _logger.i('Chat with ID $chatId successfully removed.');
    }
  }

  Future<void> _ensureDataLoaded() async {
    if (_chats.isEmpty) {
      await _loadDummyData();
    }
  }

  ContactModel _mapToArchivedContact(Contact chat) {
    return ContactModel(
        id: chat.id,
        userName: chat.userName,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        createdTime: chat.createdTime,
        isArchived: true,
        isRead: chat.isRead);
  }

  ContactModel _mapToUnarchivedContact(Contact chat) {
    return ContactModel(
        id: chat.id,
        userName: chat.userName,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        createdTime: chat.createdTime,
        isArchived: false,
        isRead: chat.isRead);
  }
}
