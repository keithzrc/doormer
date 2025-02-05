import 'package:doormer/src/shared/user/Entity/user_candidate_entity.dart';
import 'package:doormer/src/shared/user/Entity/user_employer_entity.dart';
import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:doormer/src/shared/user/Models/user_model.dart';
import 'package:doormer/src/shared/user/user_type.dart';

extension UserModelToEntity on UserModel {
  User toEntity() {
    // If the user is in PARTIAL status, return a basic User entity
    if (accountStatus == AccountStatus.partial) {
      return User(
        id: id,
        email: email,
        userType: userType,
        accountStatus: accountStatus,
      );
    } else if (userType == UserType.candidate) {
      if (firstName == null || lastName == null || mobileNumber == null) {
        throw Exception(
            'Invalid data: Candidate must have firstName and lastName');
      }
      return Candidate(
        id: id,
        email: email,
        userType: userType,
        accountStatus: accountStatus,
        firstName: firstName!,
        lastName: lastName!,
        mobileNumber: mobileNumber!,
      );
    } else if (userType == UserType.employer) {
      if (companyName == null ||
          nzbn == null ||
          companyType == null ||
          companySize == null ||
          industry == null ||
          oriented == null ||
          companyDescription == null ||
          contactFirstName == null ||
          contactLastName == null ||
          contactPhoneNumber == null) {
        throw Exception('Invalid data: Employer must have all required fields');
      }
      return Employer(
        id: id,
        email: email,
        userType: userType,
        accountStatus: accountStatus,
        companyName: companyName!,
        nzbn: nzbn!,
        companyType: companyType!,
        companySize: companySize!,
        industry: industry!,
        oriented: oriented!,
        companyDescription: companyDescription!,
        contactFirstName: contactFirstName!,
        contactLastName: contactLastName!,
        contactPhoneNumber: contactPhoneNumber!,
      );
    } else {
      throw Exception(
          'Unknown userType: $userType'); // Already an enum, no need for string checks
    }
  }
}
