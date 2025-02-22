import 'package:dartz/dartz.dart';
import 'package:doormer/src/features/home/candidate/data/datasource/candidate_home_local_datasource.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_data_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/repository/candidate_home_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:doormer/src/core/errors/failure.dart';

// TODO: conncet with remoteDatasource
class CandidateHomeRepositoryImpl implements CandidateHomeRepository {
  final CandidateHomeLocalDatasource localDataSource;

  CandidateHomeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, CandidateHomeDataEntity>> getHomeData(
      UuidValue userId) async {
    try {
      // Retrieve the DTO from the local data source.
      final homeDataDTO = await localDataSource.getCandidateHomeData(userId);
      // Convert the DTO to domain entities.
      final homeEntity = homeDataDTO.toEntity();
      return Right(homeEntity);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
