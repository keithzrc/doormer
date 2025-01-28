import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/shared/widgets/web/dropdown_menu.dart';
import 'package:doormer/src/shared/widgets/web/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCompanyInfoPageWeb extends StatelessWidget {
  const SignUpCompanyInfoPageWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuthBloc>(), // Injecting AuthBloc
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
                const CustomTextField(
                  label: 'Company Name',
                  hintText: 'Enter your company name',
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'NZBN',
                  hintText: 'Enter your NZBN',
                ),
                const SizedBox(height: 16),
                CustomDropdownMenu(
                  label: 'Company Type',
                  items: const ['Private', 'Public', 'Non-Profit'],
                  onChanged: (value) {
                    // Handle value change
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownMenu(
                  label: 'Company Size',
                  items: const ['1-10', '11-50', '51-200', '201+'],
                  onChanged: (value) {
                    // Handle value change
                  },
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Industry',
                  hintText: 'Enter your industry',
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Oriented',
                  hintText: 'Enter orientation',
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Contact Number',
                  hintText: 'Enter contact number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Contact First Name',
                  hintText: 'Enter first name',
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Contact Last Name',
                  hintText: 'Enter last name',
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Trigger AuthBloc submission or validation
                      context
                          .read<AuthBloc>()
                          .add(SignupCompanyInfoRequested());
                    },
                    child: const Text('Submit'),
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
