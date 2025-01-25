import 'dart:async';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:uuid/uuid.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';
import 'package:doormer/src/core/utils/token_storage.dart';

/// Implementation of the [ContactRepository] interface.
class ChatRepositoryImpl implements ContactRepository {
  final ChatRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });



  @override
  Future<List<Contact>> getActiveChatList(UuidValue userId) async {
    try {
      
      final remoteContacts = await remoteDataSource.getActiveChatList(userId);
      AppLogger.info('Active contacts fetched successfully: ${remoteContacts.length}');
      return remoteContacts.map((model) => model.toEntity(userId)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch active chats from remote', e);
      AppLogger.error('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<List<Contact>> getArchivedChatList(UuidValue userId) async {
    try {
            
      final remoteContacts = await remoteDataSource.getArchivedChatList(userId);
      AppLogger.info('Archived contacts fetched successfully: ${remoteContacts.length}');
      return remoteContacts.map((model) => model.toEntity(userId)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch archived chats from remote', e);
      AppLogger.error('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> updateChat(Contact updatedContact) async {
    try {
      final model = ContactModel.fromEntity(updatedContact);
      await remoteDataSource.updateChat(model);
      AppLogger.info('Chat updated successfully: ${updatedContact.id}');
    } catch (e) {
      AppLogger.error('Failed to update chat', e);
      rethrow;
    }
  }

  // @override
  // Future<void> deleteChat(String chatId) async {
  //   try {
  //     final token = await tokenStorage.getAccessToken();
  //     if (token == null) {
  //       throw Exception('No access token found');
  //     }
  //     await remoteDataSource.deleteChat(chatId);
  //     AppLogger.info('Chat deleted successfully: $chatId');
  //   } catch (e) {
  //     AppLogger.error('Failed to delete chat', e);
  //     rethrow;
  //   }
  // }

  @override
  Future<void> archiveChat(UuidValue id, UuidValue contactId, bool isArchived) async {
    try {
      await remoteDataSource.archiveChat(id, contactId, isArchived);
      AppLogger.info('Chat archive status updated successfully: ${id.toString()}');
    } catch (e) {
      AppLogger.error('Failed to update chat archive status', e);
      rethrow;
    }
  }
}

