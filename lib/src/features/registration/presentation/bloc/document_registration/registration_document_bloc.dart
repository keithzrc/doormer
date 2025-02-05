import 'dart:typed_data';
import 'package:doormer/src/features/registration/domain/usecase/registration_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_document_event.dart';
part 'registration_document_state.dart';

class RegistrationDocumentBloc
    extends Bloc<RegistrationDocumentEvent, RegistrationDocumentState> {
  final RegistrationUsecase registrationUsecase;

  RegistrationDocumentBloc({required this.registrationUsecase})
      : super(RegistrationDocumentInitial()) {
    on<UploadRegistrationDocument>(_onUploadRegistrationDocument);
  }

  Future<void> _onUploadRegistrationDocument(
    UploadRegistrationDocument event,
    Emitter<RegistrationDocumentState> emit,
  ) async {
    emit(RegistrationDocumentUploading());
    try {
      await registrationUsecase.uploadCandidateDocument(
        fileBytes: event.fileBytes,
        fileName: event.fileName,
      );
      emit(RegistrationDocumentUploaded());
    } catch (e) {
      emit(RegistrationDocumentUploadFailure(e.toString()));
    }
  }
}
