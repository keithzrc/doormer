import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_profile_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/company_match_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/news_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/profile_instruction_entity.dart';

class CandidateHomeDataEntity {
  final CandidateHomeProfile candidateProfile;
  final List<CompanyMatchEntity> companyMatches;
  final List<InstructionEntity> instructions;
  final List<NewsEntity> news;

  CandidateHomeDataEntity({
    required this.candidateProfile,
    required this.companyMatches,
    required this.instructions,
    required this.news,
  });
}
