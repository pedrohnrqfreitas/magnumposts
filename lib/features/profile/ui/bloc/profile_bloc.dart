import 'dart:async';
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
    on<ProfileWatchRequested>(_onProfileWatchRequested);
  }

  Future<void> _onProfileLoadRequested(
      ProfileLoadRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    final result = await _getProfileUseCase(event.userId);

    result.fold(
          (failure) => emit(ProfileError(message: failure.message)),
          (profile) {
        if (profile != null) {
          emit(ProfileLoaded(profile: profile));
        } else {
          emit(ProfileNotFound(userId: event.userId));
        }
      },
    );
  }

  Future<void> _onProfileCreateRequested(
      ProfileCreateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());

    final result = await _createProfileUseCase(event.params);

    result.fold(
          (failure) => emit(ProfileError(message: failure.message)),
          (_) {
        // Após criar, carregar o perfil criado
        add(ProfileLoadRequested(userId: event.params.userId));
      },
    );
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

    final result = await _updateProfileUseCase(event.params);

    result.fold(
          (failure) {
        if (currentState is ProfileLoaded) {
          emit(ProfileLoaded(profile: currentState.profile));
        }
        emit(ProfileError(message: failure.message));
      },
          (_) {
        // Após atualizar, carregar o perfil atualizado
        add(ProfileLoadRequested(userId: event.params.userId));
      },
    );
  }

  void _onProfileWatchRequested(
      ProfileWatchRequested event,
      Emitter<ProfileState> emit,
      ) {
    _profileSubscription?.cancel();

    emit(const ProfileLoading());

    _profileSubscription = _profileRepository.watchProfile(event.userId).listen(
          (profile) {
        if (profile != null) {
          emit(ProfileLoaded(profile: profile));
        } else {
          emit(ProfileNotFound(userId: event.userId));
        }
      },
      onError: (error) {
        emit(ProfileError(message: 'Erro ao observar perfil: $error'));
      },
    );
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}