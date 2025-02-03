import 'package:doormer/src/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  serverClientId: AppConfig.googleClientId, // Web client ID
  scopes: ['openid', 'email', 'profile'], // Ensure 'openid' is included
);
