import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';

class ChatRepositoryImpl implements ContactRepository {
  final RemoteDataSource remoteDataSource;
  final String currentUserId;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.currentUserId,
  });

  @override
  Future<List<Contact>> getActiveChatList() async {
    try {
      final userId = '550e8400-e29b-41d4-a716-446655440000';
      AppLogger.info('Fetching active chat list for user: $userId');
      final contactModels = await remoteDataSource.getContacts(userId);

      if (contactModels.isEmpty) {
        AppLogger.info('No contacts found');
        return [];
      }

      final contacts = contactModels
          .where((contact) => !contact.isArchived)
          .map((model) => model.toEntity())
          .toList();

      AppLogger.info(
          'Active chat list fetched successfully: ${contacts.length} contacts');
      return contacts;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch active chat list', e, stackTrace);
      return []; // Return empty list instead of throwing
    }
  }

  @override
  Future<List<Contact>> getArchivedChatList() async {
    try {
      AppLogger.info('Fetching archived chat list for user: $currentUserId');
      final contactModels = await remoteDataSource.getContacts(currentUserId);

      if (contactModels.isEmpty) {
        AppLogger.info('No contacts found');
        return [];
      }

      final contacts = contactModels
          .where((contact) => contact.isArchived)
          .map((model) => model.toEntity())
          .toList();

      AppLogger.info(
          'Archived chat list fetched successfully: ${contacts.length} contacts');
      return contacts;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch archived chat list', e, stackTrace);
      return []; // Return empty list instead of throwing
    }
  }

  @override
  Future<void> updateChat(Contact updatedContact) async {
    // TODO
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChat(String chatId) async {
    // TODO
    throw UnimplementedError();
  }
}
