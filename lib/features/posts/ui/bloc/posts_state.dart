import 'package:equatable/equatable.dart';
import '../../../../data/posts/models/post_model.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoadingMore extends PostsState {
  final List<PostModel> currentPosts;

  const PostsLoadingMore({required this.currentPosts});

  @override
  List<Object?> get props => [currentPosts];
}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final bool isRefreshing;

  const PostsLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.isRefreshing = false,
  });

  PostsLoaded copyWith({
    List<PostModel>? posts,
    bool? hasReachedMax,
    bool? isRefreshing,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax, isRefreshing];
}

class PostsError extends PostsState {
  final String message;
  final List<PostModel>? previousPosts;

  const PostsError({
    required this.message,
    this.previousPosts,
  });

  @override
  List<Object?> get props => [message, previousPosts];
}