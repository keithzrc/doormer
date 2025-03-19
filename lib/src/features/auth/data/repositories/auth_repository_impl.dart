import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:doormer/src/features/auth/data/datasources/local_data_source.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/shared/user/model/user_model_factory.dart';
import 'package:doormer/src/shared/user/user_type.dart';

class AuthRepositoryImpl implements AuthRepository {
  // final AuthRemoteDataSource dataSource;
  final AuthLocalDataSource dataSource;
  final AuthRemoteDataSource remoteDataSource;
  final SessionService sessionService;

  AuthRepositoryImpl({
    required this.dataSource,
    required this.sessionService,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    // TODO: Use userTypeValue for different user sign up
    // int userTypeValue;
    // switch (userType) {
    //   case UserType.employer:
    //     userTypeValue = 1;
    //     break;
    //   case UserType.candidate:
    //     userTypeValue = 2;
    //     break;
    // }
    final result = await remoteDataSource.signup(email, password);
    return await result.fold(
      (failure) async => Left(failure),
      (loginResponse) async {
        await sessionService.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
        );
        final userEntity = loginResponse.user.toEntity();
        return Right(userEntity);
      },
    );
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.login(email, password);
    return await result.fold(
      (failure) async => Left(failure),
      (loginResponse) async {
        AppLogger.info('$loginResponse');
        await sessionService.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
        );
        final user = loginResponse.user.toEntity();
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  }) async {
    final result = await remoteDataSource.verifyEmail(email, code);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await sessionService.logout(); // Clear tokens and reset session
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    // TODO: implement signInWithApple
    return Left(ServerFailure('Sign in with Apple is not implemented yet'));
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle(String idToken) async {
    final result = await remoteDataSource.verifyGoogleIdToken(idToken);
    return await result.fold(
      (failure) async => Left(failure),
      (loginResponse) async {
        await sessionService.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
        );
        final user = loginResponse.user.toEntity();
        return Right(user);
      },
    );
  }
}
