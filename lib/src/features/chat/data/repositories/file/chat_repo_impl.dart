import 'dart:async';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:uuid/uuid.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';

/// Implementation of the [ContactRepository] interface.
class ChatRepositoryImpl implements ContactRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Contact>> getActiveChatList(UuidValue userId) async {
    try {
      final remoteContacts = await remoteDataSource.getActiveChatList(userId);
      AppLogger.info('Active chats fetched successfully: ${remoteContacts.length}');
      return remoteContacts.map((model) => model.toEntity()).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch active chats', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Contact>> getArchivedChatList(UuidValue userId) async {
    try {
      final remoteContacts = await remoteDataSource.getArchivedChatList(userId);
      AppLogger.info('Archived chats fetched successfully: ${remoteContacts.length}');
      return remoteContacts.map((model) => model.toEntity()).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch archived chats', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateChat(Contact updatedContact) async {
    try {
      final model = ContactModel.fromEntity(updatedContact);
      await remoteDataSource.updateChat(model);
      AppLogger.info('Chat updated successfully: ${updatedContact.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update chat', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> archiveChat(UuidValue id, UuidValue contactId, bool isArchived) async {
    try {
      await remoteDataSource.archiveChat(id, contactId, isArchived);
      AppLogger.info('Chat archive status updated: ${id.toString()}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update chat archive status', e, stackTrace);
      rethrow;
    }
  }
}

