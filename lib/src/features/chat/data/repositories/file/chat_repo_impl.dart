import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  List<ContactModel> _chats = [];
  final Logger _logger = Logger();

  ChatRepositoryImpl();

  Future<void> _loadDummyData() async {
    try {
      final String response = await rootBundle.loadString(
          'lib/src/features/chat/data/repositories/file/dummydata.json');
      final List<dynamic> jsonData = json.decode(response);
      _chats = jsonData.map((data) => ContactModel.fromJson(data)).toList();
      _logger.i('Dummy data loaded successfully.');
    } catch (e) {
      _logger.e('Error loading dummy data', e);
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
      _chats[index] = _mapToArchivedContact(chat);
      _logger.i('Chat with ID $chatId archived successfully.');
    } else {
      _logger.w('Chat with ID $chatId not found.');
    }
  }

  @override
  Future<void> unarchiveChat(String chatId) {
    // TODO: implement unArchiveChat
    throw UnimplementedError();
  }

  ContactModel _mapToArchivedContact(Chat chat) {
    return ContactModel(
      id: chat.id,
      userName: chat.userName,
      avatarUrl: chat.avatarUrl,
      lastMessage: chat.lastMessage,
      createdTime: chat.createdTime,
      isArchived: true,
    );
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _ensureDataLoaded();

    final initialLength = _chats.length;

    _chats.removeWhere((chat) => chat.id == chatId);

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
          now.difference(chat.createdTime ?? DateTime(1970, 1, 1)) >
              threshold) {
        _chats[i] = ContactModel(
          id: chat.id,
          userName: chat.userName,
          avatarUrl: chat.avatarUrl,
          lastMessage: chat.lastMessage,
          createdTime: chat.createdTime,
          isArchived: true,
        );
        _logger.i('Chat with ID ${chat.id} auto-archived.');
      }
    }
  }

  Future<void> _ensureDataLoaded() async {
    if (_chats.isEmpty) {
      await _loadDummyData();
    }
  }
}
