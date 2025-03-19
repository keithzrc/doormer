import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:flutter/services.dart';
import 'package:doormer/src/features/auth/data/models/login_response_model.dart';
import 'package:doormer/src/shared/user/model/user_model.dart';

class AuthLocalDataSource {
  Future<Either<Failure, LoginResponseModel>> signup(
      String email, String password) async {
    try {
      final mockData = await _loadMockData();

      // Simulate checking credentials during signup
      if (mockData["user_info"]["email"] == email) {
        throw Exception("User already exists.");
      }

      return Right(LoginResponseModel.fromJson(mockData));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LoginResponseModel>> login(
      String email, String password) async {
    try {
      final mockData = await _loadMockData();

      // Simulate login authentication
      if (mockData["user_info"]["email"] != email ||
          password != "password123") {
        throw Exception("Invalid email or password.");
      }

      return Right(LoginResponseModel.fromJson(mockData));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> verifyEmail(String email, String code) async {
    try {
      // Simulate verification process
      if (code != "123456") {
        throw Exception("Invalid verification code.");
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> getGoogleIdToken() async {
    try {
      // Simulate fetching a Google ID token
      return const Right("mock-google-id-token");
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LoginResponseModel>> exchangeGoogleIdTokenForTokens(
      String googleIdToken) async {
    try {
      final mockData = await _loadMockData();

      // Simulate exchanging Google ID token
      if (googleIdToken != "mock-google-id-token") {
        throw Exception("Invalid Google ID token.");
      }

      return Right(LoginResponseModel.fromJson(mockData));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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

  Future<Either<Failure, UserModel>> registerCompanyInfo({
    required String companyName,
    required String nzbn,
    required String companyType,
    required String companySize,
    required String industry,
    required String oriented,
  }) async {
    try {
      // Simulate saving company info and returning updated user data
      final mockResponse = {
        "id": "7d1277f6-72f2-48ac-9fe5-4ac3903502ee",
        "email": "employer@example.com",
        "userType": "employer",
        "accountStatus": "active",
        "companyName": companyName,
        "nzbn": nzbn,
        "companyType": companyType,
        "companySize": companySize,
        "industry": industry,
        "oriented": oriented,
      };

      return Right(UserModel.fromJson(mockResponse));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> registerCandidateInfo({
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Simulate saving candidate info and returning updated user data
      final mockResponse = {
        "id": "7d1277f6-72f2-48ac-9fe5-4ac3903502ee",
        "email": "candidate@example.com",
        "userType": "candidate",
        "accountStatus": "active",
        "firstName": firstName,
        "lastName": lastName,
      };

      return Right(UserModel.fromJson(mockResponse));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
