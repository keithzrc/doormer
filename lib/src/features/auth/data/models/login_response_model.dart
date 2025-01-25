import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:doormer/src/shared/user/Models/user_model.dart';

class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final AccountStatus accountStatus;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.accountStatus,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: UserModel.fromJson(json['user']),
      accountStatus:
          AccountStatusExtension.fromApiString(json['accountStatus']),
    );
  }
}
