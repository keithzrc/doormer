class EmployerUser {
  final String id;
  final String email;
  final String companyName;
  final String industry;
  final String nzbn;
  final String address;
  final String verifiedStatus; // ACTIVE, PENDING_VERIFICATION, INACTIVE

  EmployerUser({
    required this.id,
    required this.email,
    required this.companyName,
    required this.industry,
    required this.nzbn,
    required this.address,
    required this.verifiedStatus,
  });
}
