import 'package:flutter_test/flutter_test.dart';
import 'package:magnumposts/data/posts/repository/i_posts_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/errors/failure.dart';
import 'package:magnumposts/core/result_data.dart';
import 'package:magnumposts/data/posts/models/post_model.dart';
import 'package:magnumposts/features/posts/usecase/get_posts_usecase.dart';

class MockPostsRepository extends Mock implements IPostsRepository {}

void main() {
  late GetPostsUseCase useCase;
  late MockPostsRepository mockRepository;

  setUp(() {
    mockRepository = MockPostsRepository();
    useCase = GetPostsUseCase(repository: mockRepository);
  });

  group('GetPostsUseCase', () {
    final tParams = GetPostsParams(page: 1, limit: 10);

    final tPosts = [
      PostModel(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test body',
      ),
      PostModel(
        id: 2,
        userId: 1,
        title: 'Another Post',
        body: 'Another body',
      ),
    ];

    test('should return list of posts when successful', () async {
      // arrange
      when(() => mockRepository.getPosts(page: 1, limit: 10))
          .thenAnswer((_) async => ResultData.success(tPosts));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, isA<ResultData<Failure, List<PostModel>>>());
      expect(result.isSuccess, true);

      result.fold(
            (failure) => fail('Should not return failure'),
            (posts) {
          expect(posts, hasLength(2));
          expect(posts.first.title, 'Test Post');
        },
      );

      verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Failure when repository fails', () async {
      // arrange
      final tFailure = Failure(message: 'Network error');
      when(() => mockRepository.getPosts(page: 1, limit: 10))
          .thenAnswer((_) async => ResultData.error(tFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, isA<ResultData<Failure, List<PostModel>>>());
      expect(result.isSuccess, false);

      result.fold(
            (failure) => expect(failure.message, 'Network error'),
            (posts) => fail('Should not return success'),
      );

      verify(() => mockRepository.getPosts(page: 1, limit: 10)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
