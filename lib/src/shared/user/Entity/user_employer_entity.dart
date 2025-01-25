import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:uuid/uuid.dart';

//TODO: @freezed
class Employer extends User {
  final String companyName;
  final String nzbn;
  final String companyType;
  final String companySize;
  final String industry;
  final String oriented;

  Employer({
    required UuidValue id,
    required String email,
    required UserType userType,
    required AccountStatus accountStatus,
    required this.companyName,
    required this.nzbn,
    required this.companyType,
    required this.companySize,
    required this.industry,
    required this.oriented,
  }) : super(
            id: id,
            email: email,
            userType: userType,
            accountStatus: accountStatus);
}
