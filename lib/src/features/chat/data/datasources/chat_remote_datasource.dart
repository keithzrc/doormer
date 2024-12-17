import 'package:dio/dio.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/models/chat_model.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';

class ChatRemoteDatasource {
  final Dio dio;

  ChatRemoteDatasource({required this.dio});

  /// Fetches unarchived chats from the remote API
  Future<List<ContactModel>> getUnarchivedChats() async {
    try {
      final response = await dio.get('/chats/unarchived');
      final List<dynamic> data = response.data;
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch unarchived chats: ${e.response?.data}');
    }
  }

  /// Fetches archived chats from the remote API
  Future<List<ContactModel>> getArchivedChats() async {
    try {
      final response = await dio.get('/chats/archived');
      final List<dynamic> data = response.data;
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch archived chats: ${e.response?.data}');
    }
  }

  /// Toggles chat archive state (archive/unarchive)
  Future<void> toggleChatArchiveState(String chatId) async {
    try {
      await dio.post('/chats/toggle', data: {'chatId': chatId});
    } on DioException catch (e) {
      throw Exception('Failed to toggle chat: ${e.response?.data}');
    }
  }

  /// Deletes a chat by its ID
  Future<void> deleteChat(String chatId) async {
    try {
      await dio.delete('/chats/delete', data: {'chatId': chatId});
    } on DioException catch (e) {
      throw Exception('Failed to delete chat: ${e.response?.data}');
    }
  }

  // /// Marks a chat as read or unread
  // Future<void> markChatAsRead(String chatId, bool isRead) async {
  //   try {
  //     await dio.put('/chats/mark-read', data: {
  //       'chatId': chatId,
  //       'isRead': isRead,
  //     });
  //   } on DioException catch (e) {
  //     throw Exception('Failed to mark chat as read: ${e.response?.data}');
  //   }
  // }
}
