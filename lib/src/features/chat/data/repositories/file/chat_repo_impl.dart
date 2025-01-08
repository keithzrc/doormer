import 'dart:async';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';

/// Implementation of the [ContactRepository] interface.
class ChatRepositoryImpl implements ContactRepository {
  final LocalDataSource localDataSource;
  final List<ContactModel> _chats = [];
  final Completer<void> _dataLoaded = Completer<void>();

  ChatRepositoryImpl({required this.localDataSource}) {
    // Constructor cannot await, not a problem when using API
    _initializeData();
  }

  /// Initializes data and completes the `_dataLoaded` completer when done.
  void _initializeData() async {
    AppLogger.info('Initializing data in ChatRepositoryImpl.');
    try {
      final data = await localDataSource.loadDummyData();
      _chats.addAll(data);
      AppLogger.info('Data initialized in ChatRepositoryImpl');
      _dataLoaded.complete();
    } catch (error) {
      AppLogger.error('Data initialization failed in ChatRepositoryImpl', error);
      _chats.clear();
      _dataLoaded.complete();
    }
  }

  /// Ensures data is loaded before initialization is completed.
  Future<void> _ensureDataLoaded() => _dataLoaded.future;

  @override
  Future<List<Contact>> getActiveChatList() async {
    await _ensureDataLoaded();
    final activeChats = _chats
        .where((chat) => !chat.isArchived)
        .map((chat) => chat.toEntity())
        .toList();
    AppLogger.info('Active chat list: $activeChats');
    return activeChats;
  }

  @override
  Future<List<Contact>> getArchivedChatList() async {
    await _ensureDataLoaded();
    final archivedChats = _chats
        .where((chat) => chat.isArchived)
        .map((chat) => chat.toEntity())
        .toList();
    AppLogger.info('Archived chat list: $archivedChats');
    return archivedChats;
  }

  final int indexNotFound = -1;

  @override
  Future<void> updateChat(Contact updatedContact) async {
    final updatedContactModel = ContactModel.fromEntity(updatedContact);
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
    final initialLength = _chats.length;
    _chats.removeWhere((chat) => chat.id.toString() == chatId);

    if (_chats.length == initialLength) {
      AppLogger.warn('Chat with ID $chatId not found.');
    } else {
      AppLogger.info('Chat with ID $chatId successfully removed.');
    }
  }
}
