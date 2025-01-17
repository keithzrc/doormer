import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/core/utils/app_logger.dart';

abstract class RemoteDataSource {
  Future<List<ContactModel>> getContacts(String userId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<ContactModel>> getContacts(String userId) async {
    try {
      final url = '$baseUrl/api/chat/contacts/$userId';
      AppLogger.info('Fetching contacts from: $url');
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      AppLogger.info('Response status: ${response.statusCode}');
      AppLogger.info('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        AppLogger.error(
            'Error response: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      AppLogger.error('Error fetching contacts: $e');
      return [];
    }
  }
}
