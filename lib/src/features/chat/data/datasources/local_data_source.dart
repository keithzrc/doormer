import 'dart:convert';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Path to the local dummy data file.
const fileDBPath =
    'lib/src/features/chat/data/repositories/file/dummydata.json';

/// Local data source responsible for loading dummy data.
class LocalDataSource {
  /// 缓存已加载的数据
  List<ContactModel>? _cachedContacts;

  /// Loads dummy data from the local JSON file and parses it into a list of [ContactModel].
  ///
  /// Throws an exception if the data cannot be loaded or parsed.
  Future<List<ContactModel>> loadDummyData() async {
    if (_cachedContacts != null) {
      return _cachedContacts!;
    }

    try {
      final String response = await rootBundle.loadString(fileDBPath);
      final List<dynamic> jsonData = json.decode(response);

      if (jsonData.isEmpty) {
        AppLogger.error('Dummy data JSON is empty.');
      }

      _cachedContacts =
          jsonData.map((data) => ContactModel.fromJson(data)).toList();
      return _cachedContacts!;
    } catch (e) {
      AppLogger.error('Error loading dummy data', e);
      rethrow;
    }
  }

  /// 根据ID获取用户
  Future<ContactModel?> getUserById(String id) async {
    try {
      final users = await loadDummyData();
      return users.firstWhere(
        (user) => user.id.toString() == id,
        orElse: () => throw Exception('User not found: $id'),
      );
    } catch (e) {
      AppLogger.error('Error getting user by ID: $id', e);
      rethrow;
    }
  }

  /// 获取所有可用的用户列表（用于身份选择）
  Future<List<ContactModel>> getAvailableUsers() async {
    final users = await loadDummyData();
    return users;
  }
}
