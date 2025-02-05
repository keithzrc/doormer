import 'package:dio/dio.dart';
import 'package:doormer/src/core/network/request_manager.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/data/models/login_response_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final RequestManager requestManager;
  final SessionService sessionService;
  final GoogleSignIn googleSignIn;
  final Dio dio;

  AuthRemoteDataSource(
      {required this.requestManager,
      required this.sessionService,
      required this.googleSignIn,
      required this.dio});

  // TODO: Add UserTypeValue to identify signing up company or candidate
  Future<LoginResponseModel> signup(String email, String password) async {
    try {
      final formData = FormData.fromMap({
        'auth_type': 1, // This will be sent as part of form-data
        'email': email,
        'password': password,
      });

      final response = await requestManager.post(
        '/signup',
        data: formData, // Use FormData instead of raw JSON
        requiresAuth: false,
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.error('Signup Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Signup failed');
    }
  }

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await requestManager.post(
        '/login',
        data: {'auth_type': '1', 'email': email, 'password': password},
        requiresAuth: false,
      );

      AppLogger.info('Passing to UserModel.fromJson: ${response.data}');
      return LoginResponseModel.fromJson(response.data);
    } catch (e, stacktrace) {
      AppLogger.error('Error in login API call: $e\n$stacktrace');
      throw Exception('Failed to login');
    }
  }

  // Sends verification code to verify email
  Future<void> verifyEmail(String email, String code) async {
    try {
      await requestManager.post(
        '/confirm-email', // Replace with your actual endpoint
        data: {'email': email, 'code': code},
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Email confirmation failed');
    }
  }

  Future<String> getGoogleIdTokenAndroid() async {
    try {
      // Sign out to reset the GoogleSignIn state
      await googleSignIn.signOut();

      final account = await googleSignIn.signInSilently();
      if (account == null) {
        throw Exception('User canceled Google Sign-In.');
      }

      final authentication = await account.authentication;
      AppLogger.info(
          'Google Authentication Response: ${authentication.toString()}');

      if (authentication.idToken == null) {
        throw Exception('Failed to retrieve Google ID token.');
      }

      AppLogger.info(authentication.idToken.toString());
      return authentication.idToken!;
    } catch (e) {
      AppLogger.error(e.toString());
      rethrow;
    }
  }

  // Exchange Google ID token for backend tokens
  Future<LoginResponseModel> verifyGoogleIdToken(String googleIdToken) async {
    AppLogger.info('Google Id Token: $googleIdToken');
    try {
      final formData = FormData.fromMap({
        'auth_type': 2,
        'token': googleIdToken,
      });

      final response = await requestManager.post(
        '/signup', // Your backend endpoint
        data: formData,
        requiresAuth: false,
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to exchange Google ID token for backend tokens');
      }
    } catch (e) {
      throw Exception(
          'Error while exchanging Google ID token: ${e.toString()}');
    }
  }
}
