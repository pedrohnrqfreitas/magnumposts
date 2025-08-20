import 'package:equatable/equatable.dart';
import '../../../../data/profile/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileNotFound extends ProfileState {
  final String userId;

  const ProfileNotFound({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileState {
  final ProfileModel currentProfile;

  const ProfileUpdating({required this.currentProfile});

  @override
  List<Object?> get props => [currentProfile];
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileModel profile;
  final String message;

  const ProfileUpdateSuccess({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}