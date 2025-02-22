import 'package:uuid/uuid.dart';

class CompanyMatchEntity {
  final UuidValue id; // Unique identifier for this match record.
  final String companyName;
  final String companyLogoUrl;

  CompanyMatchEntity({
    required this.id,
    required this.companyName,
    required this.companyLogoUrl,
  });
}
