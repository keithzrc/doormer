import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId:
      '594092587008-hqs52q534dk4kinurlivlhq31rncnl6v.apps.googleusercontent.com', // Web client ID
  scopes: [
    'email', // Default scope
  ],
);
