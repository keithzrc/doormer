part of 'profile_bloc.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProfileWithOptions extends ProfileEvent {
  final UuidValue userId;

  FetchProfileWithOptions({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  UpdateProfile({required this.profile});

  @override
  List<Object> get props => [profile];
}
