import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/registration/presentation/bloc/general_registration/registration_bloc.dart';
import 'package:doormer/src/shared/widgets/web/dropdown_menu.dart';
import 'package:doormer/src/shared/widgets/web/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCompanyInfoPageWeb extends StatefulWidget {
  const SignUpCompanyInfoPageWeb({Key? key}) : super(key: key);

  @override
  _SignUpCompanyInfoPageWebState createState() =>
      _SignUpCompanyInfoPageWebState();
}

class _SignUpCompanyInfoPageWebState extends State<SignUpCompanyInfoPageWeb> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController nzbnController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController orientedController = TextEditingController();

  // Dropdown selections
  String companyType = 'Private';
  String companySize = '1-10';

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    companyNameController.dispose();
    nzbnController.dispose();
    industryController.dispose();
    orientedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<RegistrationBloc>(), // Provide RegistrationBloc
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Company Info'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Enter Company Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CustomTextFieldWeb(
                  label: 'Company Name',
                  hintText: 'Enter your company name',
                  controller: companyNameController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWeb(
                  label: 'NZBN',
                  hintText: 'Enter your NZBN',
                  controller: nzbnController,
                ),
                const SizedBox(height: 16),
                CustomDropdownMenu(
                  label: 'Company Type',
                  items: const ['Private', 'Public', 'Non-Profit'],
                  onChanged: (value) {
                    setState(() {
                      companyType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownMenu(
                  label: 'Company Size',
                  items: const ['1-10', '11-50', '51-200', '201+'],
                  onChanged: (value) {
                    setState(() {
                      companySize = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFieldWeb(
                  label: 'Industry',
                  hintText: 'Enter your industry',
                  controller: industryController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWeb(
                  label: 'Oriented',
                  hintText: 'Enter orientation',
                  controller: orientedController,
                ),
                const SizedBox(height: 32),
                Center(
                  child: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        // Trigger Bloc event with collected form data
                        // TODO: Finish remianing fields
                        context
                            .read<RegistrationBloc>()
                            .add(SubmitCompanyInfoRequested(
                              companyName: companyNameController.text,
                              nzbn: nzbnController.text,
                              companyType: companyType,
                              companySize: companySize,
                              industry: industryController.text,
                              companyOrientation: orientedController.text,
                              companyDescription: "",
                              contactFirstName: "",
                              contactLastName: "",
                              contactPhoneNumber: "",
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
    );
  }
}
