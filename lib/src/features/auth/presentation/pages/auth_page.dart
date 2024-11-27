import 'package:doormer/src/core/routes/web_router.dart';
import 'package:doormer/src/features/auth/di/auth_module.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuthBloc>(),
      child: const _AuthPage(),
    );
  }
}

class _AuthPage extends StatelessWidget {
  const _AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top half: Image placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey, // Placeholder for the top image
              child: const Center(
                child: Text(
                  'Image Placeholder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // Bottom half: Button container with padding on sides
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email sign-up button
                ElevatedButton(
                  onPressed: () {
                    context.go('/auth/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:
                                  12.w), // Add padding to the left of the icon
                          child: Icon(Icons.mail_outline, color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Google sign-in button
                OutlinedButton(
                  onPressed: () {
                    // TODO: Trigger Google sign-in
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h), // Reduced height
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:
                                  10.w), // Add padding to the left of the icon
                          child: Image.asset(
                            'assets/images/logo_google_g_icon.png',
                            height: 24.h,
                            width: 24.w,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Apple sign-in button
                OutlinedButton(
                  onPressed: () {
                    // TODO: Trigger Apple sign-in
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h), // Reduced height
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:
                                  12.w), // Add padding to the left of the icon
                          child: Image.asset(
                            'assets/images/apple_icon.png',
                            height: 21.h,
                            width: 21.w,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Continue with Apple',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Bottom text and log in link
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: 'Log In',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/auth/login');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
