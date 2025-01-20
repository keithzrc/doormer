import 'package:dio/dio.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSource({required this.dio});

  Future<List<ContactModel>> getActiveChatList() async {
    try {
      final response = await dio.post('/api/chat/get-active-contacts');

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching active chats', e, stackTrace);
      throw Exception('Failed to fetch active chats');
    }
  }

  Future<List<ContactModel>> getArchivedChatList() async {
    try {
      final response = await dio.post('/api/chat/get-archived-contact');

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching archived chats', e, stackTrace);
      throw Exception('Failed to fetch archived chats');
    }
  }

  Future<void> archiveChat(UuidValue id, UuidValue contactUserId, bool isArchived) async {
    try {
      AppLogger.info('Attempting to ${isArchived ? 'archive' : 'unarchive'} chat. UserId: $id, ContactUserId: $contactUserId');
      
      final response = await dio.post(
        isArchived ? '/api/chat/archive-contact' : '/api/chat/unarchive-contact',
        data: {
          'userId': id.toString(),
          'contactUserId': contactUserId.toString(),
        },
      );
      
      AppLogger.info('Successfully ${isArchived ? 'archived' : 'unarchived'} chat $id. Response: ${response.statusCode}');
    } on DioException catch (e) {
      final errorMessage = e.response?.data['title'] ?? e.response?.data['message'] ?? 
          'Failed to ${isArchived ? 'archive' : 'unarchive'} chat';
      AppLogger.error(
        'Failed to ${isArchived ? 'archive' : 'unarchive'} chat: Status: ${e.response?.statusCode}, Message: $errorMessage',
        e,
        null
      );
      throw Exception(errorMessage);
    }
  }

  Future<void> createContact(UuidValue userId, UuidValue contactUserId) async {
    try {
      await dio.post(
        '/api/chat/create-contact',
        data: {
          'userId': userId.toString(),
          'contactUserId': contactUserId.toString(),
        },
      );
      AppLogger.info('Successfully created contact between $userId and $contactUserId');
    } on DioException catch (e) {
      AppLogger.error('Failed to create contact', e);
      throw Exception(e.response?.data['message'] ?? 'Failed to create contact');
    }
  }
}
