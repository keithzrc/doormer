import 'dart:html' as html;
import 'dart:typed_data';

import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:doormer/src/shared/widgets/web/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpCandidateInfoPageWeb extends StatefulWidget {
  const SignUpCandidateInfoPageWeb({Key? key}) : super(key: key);

  @override
  _SignUpCandidateInfoPageWebState createState() =>
      _SignUpCandidateInfoPageWebState();
}

class _SignUpCandidateInfoPageWebState
    extends State<SignUpCandidateInfoPageWeb> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String? fileName;
  Uint8List? fileBytes;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  /// Handles file selection for web
  void _pickFile() {
    final input = html.FileUploadInputElement()..accept = ".pdf,.doc,.docx";
    input.click();

    input.onChange.listen((event) {
      if (input.files!.isNotEmpty) {
        final file = input.files!.first;
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            fileBytes = reader.result as Uint8List;
            fileName = file.name;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuthBloc>(), // Provide AuthBloc
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            debugPrint("Registration successful. Navigating to /main/home");
            GoRouter.of(context).go('/main/home'); // Navigate on success
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Candidate Info'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Enter Candidate Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  CustomTextFieldWeb(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldWeb(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 24),

                  /// File Upload Section
                  const Text(
                    'Upload CV (PDF, DOC, DOCX)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text('Choose File'),
                      ),
                      const SizedBox(width: 12),
                      if (fileName != null)
                        Expanded(
                          child: Text(
                            fileName!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  /// Submit Button
                  Center(
                    child: Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(SignupCandidateInfoRequested(
                                firstNameController.text,
                                lastNameController.text,
                                fileBytes, // This is the selected file data
                                fileName, // This is the selected file name
                              ));
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
