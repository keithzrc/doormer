import 'dart:typed_data';
import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/registration/presentation/bloc/document_registration/registration_document_bloc.dart';
import 'package:doormer/src/features/registration/presentation/bloc/general_registration/registration_bloc.dart';
import 'package:doormer/src/shared/widgets/web/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpCandidateInfoPageWeb extends StatefulWidget {
  const SignUpCandidateInfoPageWeb({super.key});

  @override
  State<SignUpCandidateInfoPageWeb> createState() =>
      _SignUpCandidateInfoPageWebState();
}

class _SignUpCandidateInfoPageWebState
    extends State<SignUpCandidateInfoPageWeb> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form validation key

  bool isFormValid = false;
  bool isDocumentUploaded = false;
  bool showDocumentError = false;
  String? documentErrorMessage; // Holds error message if document upload fails

  /// Validates the phone number against NZ mobile number format
  String? _validateNZPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // NZ mobile number format (e.g., 021-xxx-xxxx, 022 xxxx xxxx, +64 21-xxx-xxxx)
    final RegExp nzPhoneRegExp =
        RegExp(r'^(?:\+64\s?|0)2[0-2,6-9](\s|-|)\d{3,4}(\s|-|)\d{3,4}$');

    if (!nzPhoneRegExp.hasMatch(value)) {
      return 'Invalid phone number';
    }

    return null;
  }

  /// Handles file selection and triggers Upload event
  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      // Ensure widget is still mounted before using context
      if (!context.mounted) return;

      context.read<RegistrationDocumentBloc>().add(
            UploadRegistrationDocument(
                fileBytes: fileBytes, fileName: fileName),
          );
    }
  }

  /// Validates form inputs and enables/disables the submit button
  void _validateForm() {
    setState(() {
      isFormValid = firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          isDocumentUploaded; // Ensure document is uploaded
    });
  }

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    phoneNumberController.addListener(_validateForm);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<RegistrationBloc>()),
        BlocProvider(
            create: (context) => serviceLocator<RegistrationDocumentBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RegistrationBloc, RegistrationState>(
            listener: (context, state) {
              if (state is CandidateRegistrationSuccess) {
                debugPrint("Registration successful. Navigating to /main/home");
                GoRouter.of(context).go('/main/home');
              }
            },
          ),
          BlocListener<RegistrationDocumentBloc, RegistrationDocumentState>(
            listener: (context, state) {
              if (state is RegistrationDocumentUploaded) {
                setState(() {
                  isDocumentUploaded = true;
                  showDocumentError =
                      false; // Clear error when file is uploaded
                  documentErrorMessage = null; // Reset error message
                });
                _validateForm();
              } else if (state is RegistrationDocumentUploadFailure) {
                setState(() {
                  isDocumentUploaded = false;
                  showDocumentError = true;
                  documentErrorMessage =
                      "Document upload failed"; // Show error message
                });
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(title: const Text('Candidate Info')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Enter Candidate Information',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    /// **First Name Field**
                    CustomTextFieldWeb(
                      label: 'First Name',
                      hintText: 'Enter your first name',
                      controller: firstNameController,
                      validator: (value) =>
                          value!.isEmpty ? 'First name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    /// **Last Name Field**
                    CustomTextFieldWeb(
                      label: 'Last Name',
                      hintText: 'Enter your last name',
                      controller: lastNameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Last name is required' : null,
                    ),
                    const SizedBox(height: 24),

                    /// **Phone Number Field with NZ Validation**
                    CustomTextFieldWeb(
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      validator:
                          _validateNZPhoneNumber, // Use external function
                    ),

                    const SizedBox(height: 24),

                    /// **File Upload Section**
                    const Text(
                      'Upload CV (PDF, DOC, DOCX) *Required',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<RegistrationDocumentBloc,
                        RegistrationDocumentState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      state is RegistrationDocumentUploading
                                          ? null
                                          : () => _pickFile(context),
                                  child: const Text('Choose File'),
                                ),
                                if (state is RegistrationDocumentUploading)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                              ],
                            ),
                            if (showDocumentError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  documentErrorMessage ??
                                      "A document must be uploaded",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    /// **Submit Button**
                    Center(
                      child: ElevatedButton(
                        onPressed: isFormValid
                            ? () {
                                if (!isDocumentUploaded) {
                                  setState(() {
                                    showDocumentError = true;
                                    documentErrorMessage =
                                        "A document must be uploaded";
                                  });
                                  return;
                                }

                                if (_formKey.currentState!.validate()) {
                                  context.read<RegistrationBloc>().add(
                                        SubmitCandidateInfoRequested(
                                          firstName:
                                              firstNameController.text.trim(),
                                          lastName:
                                              lastNameController.text.trim(),
                                          mobileNumber:
                                              phoneNumberController.text.trim(),
                                        ),
                                      );
                                }
                              }
                            : null, // Disabled if form is incomplete
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
