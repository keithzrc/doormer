import 'package:dartz/dartz.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/features/profile/domain/entity/profile.dart';
import 'package:uuid/uuid.dart';

abstract class ProfileRepository {
  /// Loads profile dropdown options from local JSON (industries, universities, etc.)
  Future<Either<Failure, Map<String, dynamic>>> getProfileOptions();

  /// Retrieves the user's current profile details from remote API
  Future<Either<Failure, Profile>> getUserProfile(UuidValue userId);

  /// Updates the user's profile with new data via remote API
  Future<Either<Failure, void>> updateUserProfile(
      UuidValue userId, Profile profileData);
}
