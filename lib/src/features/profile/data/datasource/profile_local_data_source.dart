import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProfileLocalDataSource {
  Future<Map<String, dynamic>> getProfileOptions() async {
    // Load the JSON file from assets using the correct path.
    final String jsonString = await rootBundle
        .loadString('assets/profile/candidate_profile_options.json');
    // Decode the JSON string into a Map.
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap;
  }
}
