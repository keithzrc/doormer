import 'dart:convert';
import 'package:doormer/src/features/home/candidate/data/model/home_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uuid/uuid.dart';

// Assuming HomeDataEntity and its related classes have a fromJson factory.
class CandidateHomeLocalDatasource {
  Future<HomeDataDTO> getCandidateHomeData(UuidValue userId) async {
    // Load the JSON file from the assets folder.
    final jsonString = await rootBundle
        .loadString('assets/mock/mock_candidate_home_data_response.json');

    // Decode the JSON string into a Map.
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convert the JSON map into a HomeDataEntity instance.
    return HomeDataDTO.fromJson(jsonMap);
  }
}
