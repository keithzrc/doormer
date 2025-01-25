// lib/features/auth/data/datasources/auth_remote_datasource.dart

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

  AuthRemoteDataSource(
      {required this.requestManager,
      required this.sessionService,
      required this.googleSignIn});

  // Used by candidates
  Future<LoginResponseModel> signup(String email, String password) async {
    try {
      final response = await requestManager.post(
        '/auth/signup',
        data: {'email': email, 'password': password},
        requiresAuth: false,
      );

      // Parse the response JSON and return a UserModel
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Signup failed');
    }
  }

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await requestManager.post(
        '/auth/login',
        data: {'email': email, 'password': password},
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
        '/auth/confirm-email', // Replace with your actual endpoint
        data: {'email': email, 'code': code},
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Email confirmation failed');
    }
  }

  Future<String> getGoogleIdToken() async {
    try {
      // Sign out to reset the GoogleSignIn state
      await googleSignIn.signOut();

      final account = await googleSignIn.signIn();
      if (account == null) {
        throw Exception('User canceled Google Sign-In.');
      }

      final authentication = await account.authentication;

      if (authentication.accessToken == null) {
        throw Exception('Failed to retrieve Google ID token.');
      }

      AppLogger.info(authentication.accessToken.toString());
      return authentication.accessToken!;
    } catch (e) {
      AppLogger.error(e.toString());
      rethrow;
    }
  }

  // Exchange Google ID token for backend tokens
  Future<LoginResponseModel> exchangeGoogleIdTokenForTokens(
      String googleIdToken) async {
    try {
      final response = await requestManager.post(
        '/auth/google-sign-in', // Your backend endpoint
        data: {
          'idToken': googleIdToken,
        },
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
