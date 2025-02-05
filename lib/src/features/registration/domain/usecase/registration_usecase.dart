import 'dart:typed_data';
import 'package:doormer/src/features/registration/domain/repository/registration_repository.dart';

class RegistrationUsecase {
  final RegistrationRepository repository;

  RegistrationUsecase({required this.repository});

  /// Register company information usecase
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
    await repository.registerCompanyInfo(
      companyName: companyName,
      nzbn: nzbn,
      companyType: companyType,
      companySize: companySize,
      industry: industry,
      oriented: oriented,
      companyDescription: companyDescription,
      contactFirstName: contactFirstName,
      contactLastName: contactLastName,
      contactPhoneNumber: contactPhoneNumber,
    );
  }

  /// Register candidate information usecase
  Future<void> registerCandidateInfo(
      {required String firstName,
      required String lastName,
      required String mobileNumber}) async {
    await repository.registerCandidateInfo(
        firstName: firstName, lastName: lastName, mobileNumber: mobileNumber);
  }

  /// Uploads a candidate document (e.g., resume, certifications) to Azure Storage.
  Future<void> uploadCandidateDocument({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    return await repository.uploadCandidateDocument(
      fileByte: fileBytes,
      fileName: fileName,
    );
  }
}
