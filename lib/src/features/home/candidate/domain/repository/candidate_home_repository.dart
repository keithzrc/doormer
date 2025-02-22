// lib/features/home/domain/repositories/home_repository.dart
import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_data_entity.dart';
import 'package:uuid/uuid.dart';

abstract class CandidateHomeRepository {
  // /// Fetches the candidate's display profile data for the Home page.
  // Future<Either<Failure, CandidateHomeProfile>> getCandidateHomeProfile(
  //     UuidValue userId);

  // /// Fetches the profile instructions separately.
  // Future<Either<Failure, List<InstructionEntity>>> getProfileInstructions(
  //     UuidValue userId);

  // /// Retrieves the list of companies that have matched the candidate.
  // Future<Either<Failure, List<CompanyMatchEntity>>> getCompanyMatches(
  //     UuidValue userId);

  // /// Retrieves the latest news for the Home screen.
  // Future<Either<Failure, List<NewsEntity>>> getNews();

  /// Retrieves Home data.
  Future<Either<Failure, CandidateHomeDataEntity>> getHomeData(
      UuidValue userId);
}
