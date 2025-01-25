import 'package:dio/dio.dart';
import 'package:doormer/src/core/utils/app_logger.dart';

class ChatRemoteDataSource {
  final Dio _dio;
  static const String baseUrl = 'http://localhost:5597';

  ChatRemoteDataSource(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<int> getUnreadMessageCount(int contactId) async {
    try {
      final response = await _dio.post(
        '/api/chat/get-unread-message-count',
        data: {'ContactId': contactId},
      );
      return response.data['count'] as int;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get unread message count', e, stackTrace);
      rethrow;
    }
  }
}
