import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_data_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/repository/candidate_home_repository.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/entities/user_candidate_entity.dart';
import 'package:uuid/uuid.dart';

class GetHomeData {
  final CandidateHomeRepository repository;
  final GlobalSessionBloc _globalSessionBloc;

  GetHomeData(this._globalSessionBloc, {required this.repository});

  Future<Either<Failure, CandidateHomeDataEntity>> call() async {
    // 1. Retrieve the candidate's user info from the global session.
    final user = _globalSessionBloc.getUser() as Candidate;
    final UuidValue userId = user.id;

    // 2. Retrieve the home data (a list of HomeDataEntity) from the repository.
    final homeResult = await repository.getHomeData(userId);

    return homeResult;
  }
}

    //   // 2. Retrieve candidate's display profile.
    //   final profileResult = await repository.getCandidateHomeProfile(userId);
    //   if (profileResult.isLeft()) {
    //     return profileResult.fold(
    //       (failure) => Left(failure),
    //       (_) => throw Exception("Unreachable"),
    //     );
    //   }
    //   final candidateProfile = profileResult.getOrElse(
    //     () => throw Exception("Candidate profile is null"),
    //   );

    //   // 3. Retrieve profile instructions.
    //   final instructionsResult = await repository.getProfileInstructions(userId);
    //   if (instructionsResult.isLeft()) {
    //     return instructionsResult.fold(
    //       (failure) => Left(failure),
    //       (_) => throw Exception("Unreachable"),
    //     );
    //   }
    //   final instructions = instructionsResult.getOrElse(() => []);

    //   // 4. Retrieve company matches.
    //   final companyMatchesResult = await repository.getCompanyMatches();
    //   if (companyMatchesResult.isLeft()) {
    //     return companyMatchesResult.fold(
    //       (failure) => Left(failure),
    //       (_) => throw Exception("Unreachable"),
    //     );
    //   }
    //   final companyMatches = companyMatchesResult.getOrElse(() => []);

    //   // 5. Retrieve news items.
    //   final newsResult = await repository.getNews();
    //   if (newsResult.isLeft()) {
    //     return newsResult.fold(
    //       (failure) => Left(failure),
    //       (_) => throw Exception("Unreachable"),
    //     );
    //   }
    //   final news = newsResult.getOrElse(() => []);

    //   // 6. Aggregate all data into HomeDataEntity.
    //   final homeData = HomeDataEntity(
    //     candidateProfile: candidateProfile,
    //     instructions: instructions,
    //     companyMatches: companyMatches,
    //     news: news,
    //   );

    //   return Right(homeData);
    // }
