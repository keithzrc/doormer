import 'dart:typed_data';
import 'package:doormer/src/features/registration/data/datasource/registration_remote_datasource.dart';
import 'package:doormer/src/features/registration/data/model/candidate_registration_request_model.dart';
import 'package:doormer/src/features/registration/data/model/company_registration_request_model.dart';
import 'package:doormer/src/features/registration/domain/repository/registration_repository.dart';

class RegistrationRepositoryImpl extends RegistrationRepository {
  final RegistrationRemoteDataSource dataSource;

  RegistrationRepositoryImpl({required this.dataSource});

  @override
  Future<void> registerCompanyInfo({
    required String companyName,
    required String nzbn,
    required String companyType,
    required String companySize,
    required String industry,
    required String oriented,
    required String companyDescription,
    required String contactPhoneNumber,
    required String contactFirstName,
    required String contactLastName,
  }) async {
    try {
      final request = CompanyRegistrationRequestModel(
          companyName: companyName,
          companyType: companyType,
          companySize: companySize,
          industry: industry,
          oriented: oriented,
          companyDescription: companyDescription,
          contactPhoneNumber: contactPhoneNumber,
          contactFirstName: contactFirstName,
          contactLastName: contactLastName);
      // Call the data source to register company info
      await dataSource.registerCompany(request);
    } catch (e) {
      throw Exception('Failed to register company info: $e');
    }
  }

  @override
  Future<void> registerCandidateInfo({
    required String firstName,
    required String lastName,
    required String mobileNumber,
  }) async {
    try {
      final request = CandidateRegistrationRequestModel(
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
      );
      await dataSource.registerCandidate(request);
    } catch (e) {
      throw Exception('Failed to register candidate info: $e');
    }
  }

  @override
  Future<void> uploadCandidateDocument(
      {required Uint8List fileByte, required String fileName}) async {
    try {
      // // Step 1: Request SAS URL from backend
      final String sasUrl = await dataSource.getSasUploadUrl();

      // Step 2: Upload document to Azure Blob Storage using the SAS URL
      await dataSource.uploadFileToSasUrl(fileByte, sasUrl);
    } catch (e) {
      throw Exception('Failed to upload candidate document: $e');
    }
  }
}
