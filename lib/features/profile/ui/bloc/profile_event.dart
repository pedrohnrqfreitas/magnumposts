import 'package:equatable/equatable.dart';
import '../../../../data/profile/models/params/create_profile_params.dart';
import '../../../../data/profile/models/params/update_profile_params.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;

  const ProfileLoadRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileCreateRequested extends ProfileEvent {
  final CreateProfileParams params;

  const ProfileCreateRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

class ProfileUpdateRequested extends ProfileEvent {
  final UpdateProfileParams params;

  const ProfileUpdateRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

class ProfileWatchRequested extends ProfileEvent {
  final String userId;

  const ProfileWatchRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}
