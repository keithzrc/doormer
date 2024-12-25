import 'dart:convert';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';

// TODO: move to datasource, no reinitialize data loading
const fileDBPath =
    'lib/src/features/chat/data/repositories/file/dummydata.json';

class ChatRepositoryImpl implements ContactRepository {
  List<ContactModel> _chats = [];
  ChatRepositoryImpl() {
    _loadDummyData().then((_) {
      AppLogger.info('Data initialization completed');
    }).catchError((error) {
      AppLogger.error('Data initialization failed');
    });
  }

  Future<void> _loadDummyData() async {
    try {
      final String response = await rootBundle.loadString(fileDBPath);
      final List<dynamic> jsonData = json.decode(response);
      if (jsonData.isEmpty) {
        AppLogger.error('empty json');
      }
      _chats = jsonData.map((data) => ContactModel.fromJson(data)).toList();
      AppLogger.info('Dummy data loaded successfully.');
    } catch (e) {
      AppLogger.error('Error loading dummy data', e);
      rethrow;
    }
  }

  Future<void> _ensureDataLoaded() async {
    if (_chats.isEmpty) {
      await _loadDummyData();
    }
  }

  @override
  Future<List<Contact>> getActiveChatList() async {
    await _ensureDataLoaded(); //TODO: duplicated

    // Filter unarchived chats and convert them to domain entities.
    return _chats
        .where((chat) => !chat.isArchived)
        .map((chat) => chat.toEntity())
        .toList();
  }

  @override
  Future<List<Contact>> getArchivedChatList() async {
    await _ensureDataLoaded();

    // Filter archived chats and convert them to domain entities.
    return _chats
        .where((chat) => chat.isArchived)
        .map((chat) => chat.toEntity())
        .toList();
  }

  final int indexNotFound = -1;

  @override
  Future<void> updateChat(Contact updatedContact) async {
    await _ensureDataLoaded();

    // Convert the domain entity `Contact` to the data model `ContactModel`.
    final updatedContactModel = ContactModel.fromEntity(updatedContact);

    // Find the index of the existing chat and update it.
    final index =
        _chats.indexWhere((chat) => chat.id == updatedContactModel.id);
    if (index != indexNotFound) {
      _chats[index] = updatedContactModel;
      AppLogger.info('Chat with ID ${updatedContact.id} updated successfully.');
    } else {
      AppLogger.warn('Chat with ID ${updatedContact.id} not found.');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _ensureDataLoaded();
    final initialLength = _chats.length;

    // Remove the chat with the specified ID.
    _chats.removeWhere((chat) => chat.id.toString() == chatId);

    if (_chats.length == initialLength) {
      AppLogger.warn('Chat with ID $chatId not found.');
    } else {
      AppLogger.info('Chat with ID $chatId successfully removed.');
    }
  }
}
