import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/features/profile/ui/bloc/profile_bloc.dart';
import 'package:magnumposts/features/profile/ui/bloc/profile_event.dart';
import 'package:magnumposts/features/profile/ui/bloc/profile_state.dart';
import 'package:magnumposts/features/profile/usecases/get_profile_usecase.dart';
import 'package:magnumposts/features/profile/usecases/create_profile_usecase.dart';
import 'package:magnumposts/features/profile/usecases/update_profile_usecase.dart';
import 'package:magnumposts/data/profile/repository/i_profile_repository.dart';
import 'package:magnumposts/data/profile/models/profile_model.dart';
import 'package:magnumposts/data/profile/models/params/create_profile_params.dart';
import 'package:magnumposts/data/profile/models/params/update_profile_params.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockCreateProfileUseCase extends Mock implements CreateProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}
class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;
    late MockGetProfileUseCase mockGetProfileUseCase;
    late MockCreateProfileUseCase mockCreateProfileUseCase;
    late MockUpdateProfileUseCase mockUpdateProfileUseCase;
    late MockProfileRepository mockProfileRepository;

    setUp(() {
      mockGetProfileUseCase = MockGetProfileUseCase();
      mockCreateProfileUseCase = MockCreateProfileUseCase();
      mockUpdateProfileUseCase = MockUpdateProfileUseCase();
      mockProfileRepository = MockProfileRepository();

      profileBloc = ProfileBloc(
        getProfileUseCase: mockGetProfileUseCase,
        createProfileUseCase: mockCreateProfileUseCase,
        updateProfileUseCase: mockUpdateProfileUseCase,
        profileRepository: mockProfileRepository,
      );
    });

    setUpAll(() {
      registerFallbackValue(CreateProfileParams(userId: 'test', name: 'test'));
      registerFallbackValue(UpdateProfileParams(userId: 'test'));
    });

    tearDown(() {
      profileBloc.close();
    });

    test('estado inicial deve ser ProfileInitial', () {
      expect(profileBloc.state, equals(const ProfileInitial()));
    });

    group('ProfileLoadRequested', () {
      const userId = 'user123';
      final mockProfile = ProfileModel(
        userId: userId,
        name: 'Test User',
        postsCount: 5,
        interests: ['tecnologia', 'música'],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir [ProfileLoading, ProfileLoaded] quando perfil for encontrado',
        build: () {
          when(() => mockGetProfileUseCase(userId))
              .thenAnswer((_) async => ResultData.success(mockProfile));
          return profileBloc;
        },
        act: (bloc) => bloc.add(const ProfileLoadRequested(userId: userId)),
        expect: () => [
          const ProfileLoading(),
          ProfileLoaded(profile: mockProfile),
        ],
        verify: (_) {
          verify(() => mockGetProfileUseCase(userId)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir [ProfileLoading, ProfileNotFound] quando perfil não for encontrado',
        build: () {
          when(() => mockGetProfileUseCase(userId))
              .thenAnswer((_) async => ResultData.success(null));
          return profileBloc;
        },
        act: (bloc) => bloc.add(const ProfileLoadRequested(userId: userId)),
        expect: () => [
          const ProfileLoading(),
          const ProfileNotFound(userId: userId),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir [ProfileLoading, ProfileNotFound] quando ocorrer erro',
        build: () {
          when(() => mockGetProfileUseCase(userId))
              .thenAnswer((_) async => ResultData.error(Failure(message: 'Erro ao carregar')));
          return profileBloc;
        },
        act: (bloc) => bloc.add(const ProfileLoadRequested(userId: userId)),
        expect: () => [
          const ProfileLoading(),
          const ProfileNotFound(userId: userId),
        ],
      );
    });

    group('ProfileCreateRequested', () {
      final createParams = CreateProfileParams(
        userId: 'user123',
        name: 'New User',
        age: 25,
        interests: ['esportes'],
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir [ProfileLoading, ProfileLoaded] quando perfil for criado com sucesso',
        build: () {
          when(() => mockCreateProfileUseCase(createParams))
              .thenAnswer((_) async => ResultData.success(null));
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileCreateRequested(params: createParams)),
        expect: () => [
          const ProfileLoading(),
          isA<ProfileLoaded>(),
        ],
        verify: (_) {
          verify(() => mockCreateProfileUseCase(createParams)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir ProfileCreating quando há um perfil atual',
        build: () {
          when(() => mockCreateProfileUseCase(createParams))
              .thenAnswer((_) async => ResultData.success(null));
          return profileBloc;
        },
        seed: () => ProfileLoaded(profile: ProfileModel(
          userId: 'user123',
          name: 'Existing User',
          postsCount: 0,
          interests: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        )),
        act: (bloc) => bloc.add(ProfileCreateRequested(params: createParams)),
        expect: () => [
          isA<ProfileCreating>(),
          isA<ProfileLoaded>(),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir ProfileNotFound quando criação falhar',
        build: () {
          when(() => mockCreateProfileUseCase(createParams))
              .thenAnswer((_) async => ResultData.error(Failure(message: 'Erro ao criar')));
          return profileBloc;
        },
        act: (bloc) => bloc.add(ProfileCreateRequested(params: createParams)),
        expect: () => [
          const ProfileLoading(),
          ProfileNotFound(userId: createParams.userId),
        ],
      );
    });

    group('ProfileUpdateRequested', () {
      final updateParams = UpdateProfileParams(
        userId: 'user123',
        name: 'Updated User',
        age: 30,
      );

      final existingProfile = ProfileModel(
        userId: 'user123',
        name: 'Old User',
        postsCount: 5,
        age: 25,
        interests: ['tecnologia'],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve emitir [ProfileUpdating, ProfileLoaded] quando perfil for atualizado com sucesso',
        build: () {
          when(() => mockUpdateProfileUseCase(updateParams))
              .thenAnswer((_) async => ResultData.success(null));
          return profileBloc;
        },
        seed: () => ProfileLoaded(profile: existingProfile),
        act: (bloc) => bloc.add(ProfileUpdateRequested(params: updateParams)),
        expect: () => [
          ProfileUpdating(currentProfile: existingProfile),
          isA<ProfileLoaded>(),
        ],
        verify: (_) {
          verify(() => mockUpdateProfileUseCase(updateParams)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve atualizar campos específicos do perfil',
        build: () {
          when(() => mockUpdateProfileUseCase(updateParams))
              .thenAnswer((_) async => ResultData.success(null));
          return profileBloc;
        },
        seed: () => ProfileLoaded(profile: existingProfile),
        act: (bloc) => bloc.add(ProfileUpdateRequested(params: updateParams)),
        expect: () => [
          ProfileUpdating(currentProfile: existingProfile),
          isA<ProfileLoaded>().having(
                (state) => (state).profile.name,
            'nome atualizado',
            'Updated User',
          ).having(
                (state) => (state).profile.age,
            'idade atualizada',
            30,
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'deve manter perfil existente quando atualização falhar',
        build: () {
          when(() => mockUpdateProfileUseCase(updateParams))
              .thenAnswer((_) async => ResultData.error(Failure(message: 'Erro ao atualizar')));
          return profileBloc;
        },
        seed: () => ProfileLoaded(profile: existingProfile),
        act: (bloc) => bloc.add(ProfileUpdateRequested(params: updateParams)),
        expect: () => [
          ProfileUpdating(currentProfile: existingProfile),
          ProfileLoaded(profile: existingProfile),
        ],
      );
    });
  });
}