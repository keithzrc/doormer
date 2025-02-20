import 'package:dio/dio.dart';
import 'package:doormer/src/features/profile/data/model/profile_model.dart';
import 'package:uuid/uuid.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource({required this.dio});

  Future<ProfileModel> getUserProfile(UuidValue userId) async {
    // final response = await dio.get('/profiles/${userId.toString()}');
    // return response.data;
    return ProfileModel(); //TODO: Replace with actual ProfileModel
  }

  Future<void> updateUserProfile(
      UuidValue userId, ProfileModel profileData) async {
    // final data = profileData.toJson();
    // await dio.put('/profiles/${userId.toString()}', data: data);
  }
}
