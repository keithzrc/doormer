part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to register a company
class SubmitCompanyInfoRequested extends RegistrationEvent {
  final String companyName;
  final String nzbn;
  final String companyType;
  final String companySize;
  final String industry;
  final String companyOrientation;
  final String companyDescription;
  final String contactPhoneNumber;
  final String contactFirstName;
  final String contactLastName;

  SubmitCompanyInfoRequested({
    required this.companyName,
    required this.nzbn,
    required this.companyType,
    required this.companySize,
    required this.industry,
    required this.companyOrientation,
    required this.companyDescription,
    required this.contactPhoneNumber,
    required this.contactFirstName,
    required this.contactLastName,
  });

  @override
  List<Object?> get props => [
        companyName,
        nzbn,
        companyType,
        companySize,
        industry,
        companyOrientation,
        companyDescription,
        contactFirstName,
        contactLastName,
        contactPhoneNumber,
      ];
}

/// Event to register a candidate
class SubmitCandidateInfoRequested extends RegistrationEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;

  SubmitCandidateInfoRequested(
      {required this.firstName,
      required this.lastName,
      required this.mobileNumber});

  @override
  List<Object?> get props => [firstName, lastName, mobileNumber];
}
