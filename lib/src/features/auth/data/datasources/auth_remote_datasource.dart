// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import '../../../../shared/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<UserModel> signup(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/signup',
        data: {'email': email, 'password': password},
      );

      // Parse the response JSON and return a UserModel
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Signup failed');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      AppLogger.info('Passing to UserModel.fromJson: ${response.data}');
      return UserModel.fromJson(response.data);
    } catch (e, stacktrace) {
      AppLogger.error('Error in login API call: $e\n$stacktrace');
      throw Exception('Failed to login');
    }
  }

  Future<void> confirmEmail(String email, String code) async {
    try {
      await dio.post(
        '/auth/confirm-email', // Replace with your actual endpoint
        data: {'email': email, 'code': code},
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Email confirmation failed');
    }
  }
}
