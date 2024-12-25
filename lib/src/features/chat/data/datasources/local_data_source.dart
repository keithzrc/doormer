import 'dart:convert';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Path to the local dummy data file.
const fileDBPath =
    'lib/src/features/chat/data/repositories/file/dummydata.json';

/// Local data source responsible for loading dummy data.
class LocalDataSource {
  /// Loads dummy data from the local JSON file and parses it into a list of [ContactModel].
  ///
  /// Throws an exception if the data cannot be loaded or parsed.
  Future<List<ContactModel>> loadDummyData() async {
    try {
      final String response = await rootBundle.loadString(fileDBPath);
      final List<dynamic> jsonData = json.decode(response);

      if (jsonData.isEmpty) {
        AppLogger.error('Dummy data JSON is empty.');
      }

      return jsonData.map((data) => ContactModel.fromJson(data)).toList();
    } catch (e) {
      AppLogger.error('Error loading dummy data', e);
      rethrow;
    }
  }
}
