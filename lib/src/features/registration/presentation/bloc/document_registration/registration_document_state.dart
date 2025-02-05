part of 'registration_document_bloc.dart';

abstract class RegistrationDocumentState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state
class RegistrationDocumentInitial extends RegistrationDocumentState {}

/// File upload in progress
class RegistrationDocumentUploading extends RegistrationDocumentState {}

/// File uploaded successfully to Azure
class RegistrationDocumentUploaded extends RegistrationDocumentState {}

/// File upload failed
class RegistrationDocumentUploadFailure extends RegistrationDocumentState {
  final String error;

  RegistrationDocumentUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
