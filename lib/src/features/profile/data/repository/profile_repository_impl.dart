import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:doormer/src/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:doormer/src/features/profile/domain/entity/candidate_profile.dart';
import 'package:doormer/src/features/profile/domain/entity/profile.dart';
import 'package:doormer/src/features/profile/domain/repository/profile_repository.dart';
import 'package:uuid/uuid.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProfileOptions() async {
    try {
      final options = await localDataSource.getProfileOptions();
      return Right(options);
    } catch (e) {
      return Left(DatabaseFailure("Failed to load profile options"));
    }
  }

  @override
  Future<Either<Failure, Profile>> getUserProfile(UuidValue userId) async {
    try {
      // final profileModel = await remoteDataSource.getUserProfile(userId);
      //TODO: Use actual profile.toEntity()
      return Right(CandidateProfile(
        userId: UuidValue("7d1277f6-72f2-48ac-9fe5-4ac3903502ee"),
        expectations: [],
        companySizes: ["large international company"],
        cultures: [
          "Encourages creativity and experimentation.",
          "Values new ideas and promotes innovation.",
          "Emphasizes teamwork and open communication."
        ],
        roles: ["AI engineer", "web engineer", "Data Scientist/Analyst"],
        industries: ["IT/Communication", "Software/information processing"],
        firstName: "Mary",
        lastName: "Chan",
        educationLevel: "Bachelor",
        university: "University of Auckland",
        skillset: [
          "Flutter",
          "Dart",
          "C#",
          "Python",
          "SQL",
        ],
        certifications: [],
        profileAvatar: "",
      ));
    } on DioException catch (e) {
      return Left(ServerFailure("Error retrieving profile: ${e.message}"));
    } catch (e) {
      return Left(UnknownFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(
      UuidValue userId, Profile profile) async {
    try {
      // profileModel = ProfileModelExtension.toModel(profile)
      // await remoteDataSource.updateUserProfile(userId, profileModel);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure("Profile update failed: ${e.message}"));
    } catch (e) {
      return Left(UnknownFailure("Unexpected error: ${e.toString()}"));
    }
  }
}
