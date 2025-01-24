import 'package:doormer/src/shared/user/Entity/user_candidate_entity.dart';
import 'package:doormer/src/shared/user/Entity/user_employer_entity.dart';
import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/Models/user_model.dart';

extension UserModelToEntity on UserModel {
  User toEntity() {
    if (userType == 'candidate') {
      if (firstName == null || lastName == null) {
        throw Exception(
            'Invalid data: Candidate must have firstName and lastName');
      }
      return Candidate(
        id: id,
        email: email,
        userType: userType,
        firstName: firstName!,
        lastName: lastName!,
      );
    } else if (userType == 'employer') {
      if (companyName == null ||
          nzbn == null ||
          companyType == null ||
          companySize == null ||
          industry == null ||
          oriented == null) {
        throw Exception('Invalid data: Employer must have all required fields');
      }
      return Employer(
        id: id,
        email: email,
        userType: userType,
        companyName: companyName!,
        nzbn: nzbn!,
        companyType: companyType!,
        companySize: companySize!,
        industry: industry!,
        oriented: oriented!,
      );
    } else {
      throw Exception('Unknown userType: $userType');
    }
  }
}
