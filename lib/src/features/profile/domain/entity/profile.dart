import 'package:uuid/uuid.dart';

class Profile {
  ///base class for different profile types (Candidate, Employer)
  final UuidValue userId;
  Profile({required this.userId});
}
