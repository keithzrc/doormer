// TODO: @JsonSerializable

class CompanyRegistrationRequestModel {
  final String companyName;
  final String? nzbn;
  final String companyType;
  final String companySize;
  final String industry;
  final String oriented;
  final String companyDescription;
  final String contactPhoneNumber;
  final String contactFirstName;
  final String contactLastName;

  CompanyRegistrationRequestModel({
    required this.companyName,
    this.nzbn,
    required this.companyType,
    required this.companySize,
    required this.industry,
    required this.oriented,
    required this.companyDescription,
    required this.contactPhoneNumber,
    required this.contactFirstName,
    required this.contactLastName,
  });

  /// Converts JSON to Model
  factory CompanyRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return CompanyRegistrationRequestModel(
      companyName: json['company_name'] as String,
      nzbn: json['nzbn'] as String?,
      companyType: json['company_type'] as String,
      companySize: json['company_size'] as String,
      industry: json['industry'] as String,
      oriented: json['oriented'] as String,
      companyDescription: json['company_description'] as String,
      contactPhoneNumber: json['contact_phone_number'] as String,
      contactFirstName: json['contact_first_name'] as String,
      contactLastName: json['contact_last_name'] as String,
    );
  }

  /// Converts Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'nzbn': nzbn,
      'company_type': companyType,
      'company_size': companySize,
      'industry': industry,
      'oriented': oriented,
      'company_description': companyDescription,
      'contact_phone_number': contactPhoneNumber,
      'contact_first_name': contactFirstName,
      'contact_last_name': contactLastName,
    };
  }
}
