import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/core/errors/failure_mapper.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/data/models/login_response_model.dart';
import 'package:doormer/src/features/auth/errors/auth_error_mapper.dart';
import 'package:doormer/src/features/auth/errors/auth_failures.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final SessionService sessionService;
  final GoogleSignIn googleSignIn;
  final Dio dio;

  AuthRemoteDataSource({
    required this.sessionService,
    required this.googleSignIn,
    required this.dio,
  });

  /// Sign up endpoint: Connects to the backend and returns the response.
  Future<Either<Failure, LoginResponseModel>> signup(
      String email, String password) async {
    try {
      final formData = FormData.fromMap({
        'auth_type': 1,
        'email': email,
        'password': password,
      });

      final response = await dio.post(
        '/signup',
        data: formData,
        options: Options(extra: {'skipAuth': true}),
      );

      return Right(LoginResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      AppLogger.error('Signup Error: ${e.response?.data}');
      return Left(authErrorMapper(e));
    } catch (e) {
      AppLogger.error('Signup Unexpected Error: $e');
      return Left(genericErrorMapper(e));
    }
  }

  /// Login endpoint: Connects to the backend and returns the response.
  Future<Either<Failure, LoginResponseModel>> login(
      String email, String password) async {
    try {
      final formData = FormData.fromMap({
        'auth_type': 1,
        'email': email,
        'password': password,
      });
      final response = await dio.post(
        '/login',
        data: formData,
        options: Options(extra: {'skipAuth': true}),
      );

      AppLogger.info('Passing to UserModel.fromJson: ${response.data}');
      return Right(LoginResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      AppLogger.error('Login Error: ${e.response?.data}');
      return Left(authErrorMapper(e));
    } catch (e) {
      AppLogger.error('Login Unexpected Error: $e');
      return Left(genericErrorMapper(e));
    }
  }

  /// Verify Email endpoint: Connects to the backend for email verification.
  Future<Either<Failure, void>> verifyEmail(String email, String code) async {
    try {
      await dio.post(
        '/confirm-email',
        data: {'email': email, 'code': code},
      );
      return const Right(null);
    } on DioException catch (e) {
      AppLogger.error('Verify Email Error: ${e.response?.data}');
      return Left(authErrorMapper(e));
    } catch (e) {
      AppLogger.error('Verify Email Unexpected Error: $e');
      return Left(genericErrorMapper(e));
    }
  }

  /// Retrieve Google ID token on Android: Connects to Google Sign-In.
  Future<Either<Failure, String>> getGoogleIdTokenAndroid() async {
    try {
      // Sign out to reset the GoogleSignIn state.
      await googleSignIn.signOut();

      final account = await googleSignIn.signInSilently();
      if (account == null) {
        return const Left(GoogleSignInCancelled());
      }

      final authentication = await account.authentication;
      AppLogger.info('Google Authentication Response: $authentication');

      if (authentication.idToken == null) {
        return const Left(GoogleTokenFailure());
      }

      return Right(authentication.idToken!);
    } on DioException catch (e) {
      AppLogger.error('Google Sign-In Dio Error: ${e.response?.data}');
      return Left(authErrorMapper(e));
    } catch (e) {
      AppLogger.error('Google Sign-In Unexpected Error: $e');
      return Left(genericErrorMapper(e));
    }
  }

  /// Exchange Google ID token for backend tokens.
  Future<Either<Failure, LoginResponseModel>> verifyGoogleIdToken(
      String googleIdToken) async {
    try {
      AppLogger.info('Google Id Token: $googleIdToken');
      final formData = FormData.fromMap({
        'auth_type': 2,
        'token': googleIdToken,
      });

      final response = await dio.post(
        '/signup', // Your backend endpoint for Google token exchange.
        data: formData,
        options: Options(extra: {'skipAuth': true}),
      );

      if (response.statusCode == 200) {
        return Right(LoginResponseModel.fromJson(response.data));
      } else {
        return const Left(BackendTokenExchangeFailure());
      }
    } on DioException catch (e) {
      AppLogger.error('Verify Google ID Token Error: ${e.response?.data}');
      return Left(authErrorMapper(e));
    } catch (e) {
      AppLogger.error('Verify Google ID Token Unexpected Error: $e');
      return Left(genericErrorMapper(e));
    }
  }
}
