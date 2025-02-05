import 'dart:typed_data';

abstract class RegistrationRepository {
  /// Register employer (company) information
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
  });

  /// Register candidate information
  Future<void> registerCandidateInfo({
    required String firstName,
    required String lastName,
    required String mobileNumber,
  });

  /// Uploads file to Microsoft SAS
  Future<void> uploadCandidateDocument(
      {required Uint8List fileByte, required String fileName});
}
