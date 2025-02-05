part of 'registration_document_bloc.dart';

abstract class RegistrationDocumentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to upload a document (resume, certifications) during registration
class UploadRegistrationDocument extends RegistrationDocumentEvent {
  final Uint8List fileBytes;
  final String fileName;

  UploadRegistrationDocument({required this.fileBytes, required this.fileName});

  @override
  List<Object?> get props => [fileBytes, fileName];
}
