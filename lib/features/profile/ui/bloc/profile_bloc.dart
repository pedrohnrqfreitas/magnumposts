import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/profile/models/profile_model.dart';
import '../../../../data/profile/repository/i_profile_repository.dart';
import '../../usecases/create_profile_usecase.dart';
import '../../usecases/get_profile_usecase.dart';
import '../../usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final CreateProfileUseCase _createProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final IProfileRepository _profileRepository;

  StreamSubscription<ProfileModel?>? _profileSubscription;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required CreateProfileUseCase createProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required IProfileRepository profileRepository,
  })  : _getProfileUseCase = getProfileUseCase,
        _createProfileUseCase = createProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _profileRepository = profileRepository,
        super(const ProfileInitial()) {

    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileCreateRequested>(_onProfileCreateRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  Future<void> _onProfileLoadRequested(
      ProfileLoadRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    try {
      final result = await _getProfileUseCase(event.userId);

      result.fold(
            (_) => emit(ProfileNotFound(userId: event.userId)),
            (profile) {
          if (profile != null) {
            emit(ProfileLoaded(profile: profile));
          } else {
            emit(ProfileNotFound(userId: event.userId));
          }
        },
      );
    } catch (e) {
      emit(ProfileNotFound(userId: event.userId));
    }
  }

  Future<void> _onProfileCreateRequested(
      ProfileCreateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileCreating(currentProfile: currentState.profile));
    } else {
      emit(const ProfileLoading());
    }

    try {
      final result = await _createProfileUseCase(event.params);

      result.fold(
            (failure) {
          emit(ProfileNotFound(userId: event.params.userId));
        },
            (_) {
          final mockProfile = ProfileModel(
            userId: event.params.userId,
            name: event.params.name,
            imageUrl: event.params.imageUrl,
            postsCount: 0,
            age: event.params.age,
            interests: event.params.interests,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          emit(ProfileLoaded(profile: mockProfile));
        },
      );
    } catch (e) {
      emit(ProfileNotFound(userId: event.params.userId));
    }
  }

  Future<void> _onProfileUpdateRequested(
      ProfileUpdateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentProfile: currentState.profile));
    } else {
      emit(const ProfileLoading());
    }

    try {
      final result = await _updateProfileUseCase(event.params);

      result.fold(
            (failure) {
          // Em caso de erro, voltar ao estado anterior se possível
          if (currentState is ProfileLoaded) {
            emit(ProfileLoaded(profile: currentState.profile));
          } else {
            emit(ProfileNotFound(userId: event.params.userId));
          }
        },
            (_) {

            // Sucesso - criar perfil atualizado e emitir
          final updatedProfile = currentState is ProfileLoaded
              ? currentState.profile.copyWith(
            name: event.params.name,
            age: event.params.age,
            interests: event.params.interests,
            updatedAt: DateTime.now(),
          )
              : ProfileModel(
            userId: event.params.userId,
            name: event.params.name ?? 'Nome',
            postsCount: event.params.postsCount ?? 0,
            age: event.params.age,
            interests: event.params.interests ?? [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          emit(ProfileLoaded(profile: updatedProfile));
        },
      );
    } catch (e) {
      // Exceção - voltar ao estado anterior ou not found
      if (currentState is ProfileLoaded) {
        emit(ProfileLoaded(profile: currentState.profile));
      } else {
        emit(ProfileNotFound(userId: event.params.userId));
      }
    }
  }


  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}