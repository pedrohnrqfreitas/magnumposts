import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class PostsLoadRequested extends PostsEvent {
  final bool isRefresh;

  const PostsLoadRequested({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class PostsLoadMoreRequested extends PostsEvent {
  const PostsLoadMoreRequested();
}

class PostRefreshRequested extends PostsEvent {
  const PostRefreshRequested();
}