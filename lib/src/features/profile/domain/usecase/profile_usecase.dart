import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/profile/domain/entity/profile.dart';
import 'package:doormer/src/features/profile/domain/repository/profile_repository.dart';
import 'package:uuid/uuid.dart';

class ProfileUseCases {
  final ProfileRepository repository;

  late final LoadProfileOptions loadProfileOptions;
  late final GetUserProfile getUserProfile;
  late final UpdateUserProfile updateUserProfile;

  ProfileUseCases({required this.repository}) {
    loadProfileOptions = LoadProfileOptions(repository);
    getUserProfile = GetUserProfile(repository);
    updateUserProfile = UpdateUserProfile(repository);
  }
}

/// Load profile options use case
class LoadProfileOptions {
  final ProfileRepository repository;

  LoadProfileOptions(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return repository.getProfileOptions();
  }
}

/// Get user profile use case
class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, Profile>> call(UuidValue userId) async {
    return repository.getUserProfile(userId);
  }
}

/// Update user profile use case
class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, void>> call(
      UuidValue userId, Profile updatedProfile) async {
    return repository.updateUserProfile(userId, updatedProfile);
  }
}
