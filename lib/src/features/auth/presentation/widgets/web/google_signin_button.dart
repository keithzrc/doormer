import 'package:doormer/src/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();

    // Retrieve the GoogleSignIn instance from serviceLocator
    _googleSignIn = serviceLocator<GoogleSignIn>();

    // Listen for sign-in events
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _handleGoogleSignIn(account);
      }
    });
  }

  void _handleGoogleSignIn(GoogleSignInAccount account) async {
    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;

    if (!mounted) return; // Prevent calling context if the widget is disposed

    if (idToken != null) {
      // Dispatch Bloc event with the retrieved ID token
      context.read<AuthBloc>().add(GoogleSignInRequested(idToken));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Render Google Sign-In button
        (GoogleSignInPlatform.instance as web.GoogleSignInPlugin)
            .renderButton(),
      ],
    );
  }
}
