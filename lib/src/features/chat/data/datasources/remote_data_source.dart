import 'package:dio/dio.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSource({required this.dio});

  Future<List<ContactModel>> getActiveChatList(UuidValue userId) async {

    try {
      final response = await dio.post(
        '/api/chat/get-active-contacts',
        queryParameters: {
          'userId': userId.toString(),
        },
      );
      
      AppLogger.info('Active contacts response: ${response.data}');
      return (response.data as List)
          .map((json) => ContactModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      AppLogger.error('Error in getActiveChatList API call: $e');
      rethrow;
    }
  }

  Future<List<ContactModel>> getArchivedChatList(UuidValue userId) async {

    try {
      final response = await dio.post(
        '/api/chat/get-archived-contact',
        queryParameters: {
          'userId': userId.toString(),
        },
      );
      AppLogger.info('Archived contacts response: ${response.data}');
      return (response.data as List)
          .map((json) => ContactModel.fromJson(json))
          .toList();

    } on DioException catch (e) {
      AppLogger.error('Error in getArchivedChatList API call: $e');
      rethrow;
    }
  }

  Future<void> archiveChat(UuidValue id, UuidValue contactId, bool isArchived) async {
    try {
      await dio.post(
        isArchived ? '/api/chat/archive-contact' : '/api/chat/unarchive-contact',
        data: {
          'userId': id.toString(),
          'contactUserId': contactId.toString(),
          'isArchived': isArchived
        },
      );
    } on DioException catch (e) {
      AppLogger.error('Error in archiveChat API call: $e');
      rethrow;
    }
  }

  Future<void> createContact(UuidValue userId, UuidValue contactUserId) async {
    try {
      await dio.post(
        '/create-contact',
        data: {
          'userId': userId.toString(),
          'contactUserId': contactUserId.toString(),
        },
      );
    } on DioException catch (e) {
      AppLogger.error('Error in createContact API call: $e');
      rethrow;
    }
  }

  Future<void> updateChat(ContactModel contact) async {
    try {
      await archiveChat(
        contact.id,
        contact.id,
        contact.isArchived,
      );
    } on DioException catch (e) {
      AppLogger.error('Error in updateChat API call: $e');
      rethrow;
    }
  }
}
