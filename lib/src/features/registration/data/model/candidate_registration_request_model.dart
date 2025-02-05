// TODO: Use JsonSerializable when finalized
class CandidateRegistrationRequestModel {
  final String mobileNumber;
  final String firstName;
  final String lastName;

  CandidateRegistrationRequestModel({
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      "mobile_number": mobileNumber,
      "first_name": firstName,
      "last_name": lastName,
    };
  }
}
