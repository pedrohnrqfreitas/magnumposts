import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../usecase/get_posts_usecase.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase _getPostsUseCase;

  static const int _postsPerPage = 10;
  int _currentPage = 1;
  bool _hasReachedMax = false;

  PostsBloc({
    required GetPostsUseCase getPostsUseCase,
  }) : _getPostsUseCase = getPostsUseCase,
        super(const PostsInitial()) {

    on<PostsLoadRequested>(_onPostsLoadRequested);
    on<PostsLoadMoreRequested>(_onPostsLoadMoreRequested);
    on<PostRefreshRequested>(_onPostRefreshRequested);
  }

  Future<void> _onPostsLoadRequested(
      PostsLoadRequested event,
      Emitter<PostsState> emit,
      ) async {
    if (event.isRefresh) {
      _resetPagination();
      emit(const PostsLoading());
    } else if (state is! PostsLoaded) {
      emit(const PostsLoading());
    }

    await _loadPosts(emit, isRefresh: event.isRefresh);
  }

  Future<void> _onPostsLoadMoreRequested(
      PostsLoadMoreRequested event,
      Emitter<PostsState> emit,
      ) async {
    final currentState = state;
    if (currentState is PostsLoaded && !currentState.hasReachedMax) {
      emit(PostsLoadingMore(currentPosts: currentState.posts));

      _currentPage++;
      await _loadPosts(emit, isLoadMore: true, currentPosts: currentState.posts);
    }
  }

  Future<void> _onPostRefreshRequested(
      PostRefreshRequested event,
      Emitter<PostsState> emit,
      ) async {
    _resetPagination();

    final currentState = state;
    if (currentState is PostsLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const PostsLoading());
    }

    await _loadPosts(emit, isRefresh: true);
  }

  Future<void> _loadPosts(
      Emitter<PostsState> emit, {
        bool isLoadMore = false,
        bool isRefresh = false,
        List<PostModel>? currentPosts,
      }) async {
    final params = GetPostsParams(
      page: _currentPage,
      limit: _postsPerPage,
    );

    final result = await _getPostsUseCase(params);

    result.fold(
          (failure) {
        if (isLoadMore && currentPosts != null) {
          _currentPage--; // Reverter incremento em caso de erro
          emit(PostsLoaded(
            posts: currentPosts,
            hasReachedMax: _hasReachedMax,
          ));
        } else {
          emit(PostsError(
            message: failure.message,
            previousPosts: currentPosts,
          ));
        }
      },
          (newPosts) {
        List<PostModel> allPosts;

        if (isLoadMore && currentPosts != null) {
          allPosts = [...currentPosts, ...newPosts];
        } else {
          allPosts = newPosts;
        }

        // Verificar se chegou ao final
        _hasReachedMax = newPosts.length < _postsPerPage;

        emit(PostsLoaded(
          posts: allPosts,
          hasReachedMax: _hasReachedMax,
        ));
      },
    );
  }

  void _resetPagination() {
    _currentPage = 1;
    _hasReachedMax = false;
  }
}