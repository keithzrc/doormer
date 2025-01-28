import 'dart:convert';
import 'package:doormer/src/features/auth/data/models/login_response_model.dart';
import 'package:flutter/services.dart';

class AuthLocalDataSource {
  Future<LoginResponseModel> signup(String email, String password) async {
    final mockData = await _loadMockData();

    // Simulate checking credentials during signup
    if (mockData["user_info"]["email"] == email) {
      throw Exception("User already exists.");
    }

    return LoginResponseModel.fromJson(mockData);
  }

  Future<LoginResponseModel> login(String email, String password) async {
    final mockData = await _loadMockData();

    // Simulate login authentication
    if (mockData["user_info"]["email"] != email || password != "password123") {
      throw Exception("Invalid email or password.");
    }

    return LoginResponseModel.fromJson(mockData);
  }

  Future<void> verifyEmail(String email, String code) async {
    // Simulate verification process
    if (code != "123456") {
      throw Exception("Invalid verification code.");
    }
  }

  Future<String> getGoogleIdToken() async {
    // Simulate fetching a Google ID token
    return "mock-google-id-token";
  }

  Future<LoginResponseModel> exchangeGoogleIdTokenForTokens(
      String googleIdToken) async {
    final mockData = await _loadMockData();

    // Simulate exchanging Google ID token
    if (googleIdToken != "mock-google-id-token") {
      throw Exception("Invalid Google ID token.");
    }

    return LoginResponseModel.fromJson(mockData);
  }

  Future<Map<String, dynamic>> _loadMockData() async {
    try {
      // Load the JSON file from the assets/mock directory
      final mockJson =
          await rootBundle.loadString('assets/mock/mock_login_response.json');
      return json.decode(mockJson);
    } catch (e) {
      throw Exception('Failed to load mock data: $e');
    }
  }
}
