import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/login_page_web.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/signup_page_web.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPageWeb extends StatefulWidget {
  const AuthPageWeb({super.key});

  @override
  State<AuthPageWeb> createState() => _AuthPageWebState();
}

class _AuthPageWebState extends State<AuthPageWeb> {
  bool isLoginPage = true;
  UserType userType = UserType.employer; // Default user type
  List<bool> isSelected = [true, false]; // Toggle button state

  void toggleAuthMode() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  void toggleUserType(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
      userType = index == 0 ? UserType.employer : UserType.candidate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Inject the AuthBloc directly using GetIt
      create: (context) => serviceLocator<AuthBloc>(),
      child: Scaffold(
        body: Row(
          children: [
            // Left Section: Placeholder for the Logo
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    'LOGO',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // Right Section: Toggle between Login and Sign-Up Pages
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(8.0),
                        isSelected: isSelected,
                        onPressed: toggleUserType,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text("Job-Seeker"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text("Employer"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: isLoginPage
                        ? LoginPageWeb(
                            onSwitchAuthMode: toggleAuthMode,
                            userType: userType,
                          )
                        : SignUpPageWeb(
                            onSwitchAuthMode: toggleAuthMode,
                            userType: userType,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
