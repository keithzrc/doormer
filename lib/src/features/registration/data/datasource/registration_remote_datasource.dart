import 'dart:typed_data';

import 'package:doormer/src/core/network/request_manager.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/registration/data/model/candidate_registration_request_model.dart';
import 'package:doormer/src/features/registration/data/model/company_registration_request_model.dart';

class RegistrationRemoteDataSource {
  final RequestManager requestManager;

  RegistrationRemoteDataSource({required this.requestManager});

  /// Fetch a SAS Upload URL for the given file name
  Future<String> getSasUploadUrl(String fileName) async {
    try {
      final response = await requestManager.get(
        '/document/sas-url',
        queryParams: {'fileName': fileName},
        requiresAuth: true,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['sasUrl'];
      } else {
        throw Exception('Failed to retrieve SAS upload URL');
      }
    } catch (e) {
      AppLogger.error('Failed to get SAS URL: $e');
      throw Exception('Error fetching SAS upload URL: $e');
    }
  }

  /// Upload the file to Azure Blob Storage using the SAS URL
  Future<void> uploadFileToSasUrl(Uint8List fileBytes, String sasUrl) async {
    try {
      await requestManager.put(
        sasUrl,
        data: fileBytes,
        requiresAuth: false,
      );
    } catch (e) {
      AppLogger.error('File upload failed: $e');
      throw Exception('Error uploading file: $e');
    }
  }

  /// Register a candidate
  Future<void> registerCandidate(
      CandidateRegistrationRequestModel request) async {
    try {
      await requestManager.post(
        '/candidate/register',
        data: request.toJson(),
        requiresAuth: true,
      );
    } catch (e) {
      AppLogger.error('Candidate registration failed: $e');
      throw Exception('Error registering candidate: $e');
    }
  }

  /// Register a company
  Future<void> registerCompany(CompanyRegistrationRequestModel request) async {
    try {
      await requestManager.post(
        '/company/register',
        data: request.toJson(),
        requiresAuth: true,
      );
    } catch (e) {
      AppLogger.error('Company registration failed: $e');
      throw Exception('Error registering company: $e');
    }
  }
}
