import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnumposts/core/widgets/app_empty_state.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';
import '../../../authentication/ui/bloc/auth_bloc.dart';
import '../../../authentication/ui/bloc/auth_event.dart';
import '../../../authentication/ui/bloc/auth_state.dart';
import '../../../authentication/ui/pages/login_page.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';
import '../../usecase/get_user_by_id_usecase.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';
import '../widget/logout_bottomsheet.dart';
import '../widget/post_card_widget.dart';
import '../widget/post_skeleton_card.dart';
import 'post_detail_page.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, UserPostModel> _authorsCache = {};
  final Set<int> _loadingAuthors = {};

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _loadInitialPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * AppConstants.scrollThreshold) {
        _loadMorePosts();
      }
    });
  }

  void _loadInitialPosts() {
    context.read<PostsBloc>().add(const PostsLoadRequested());
  }

  void _loadMorePosts() {
    context.read<PostsBloc>().add(const PostsLoadMoreRequested());
  }

  void _refreshPosts() {
    _authorsCache.clear();
    _loadingAuthors.clear();
    context.read<PostsBloc>().add(const PostRefreshRequested());
  }

  Future<void> _loadAuthorForPost(int userId) async {
    if (_authorsCache.containsKey(userId) || _loadingAuthors.contains(userId)) {
      return;
    }

    _loadingAuthors.add(userId);

    try {
      final getUserUseCase = context.read<GetUserByIdUseCase>();
      final result = await getUserUseCase(userId);

      result.fold(
            (failure) {
          _loadingAuthors.remove(userId);
        },
            (user) {
          if (mounted) {
            setState(() {
              _authorsCache[userId] = user;
              _loadingAuthors.remove(userId);
            });
          }
        },
      );
    } catch (e) {
      _loadingAuthors.remove(userId);
    }
  }

  void _loadAuthorsForPosts(List<PostModel> posts) {
    final uniqueUserIds = posts.map((post) => post.userId).toSet();

    for (final userId in uniqueUserIds) {
      _loadAuthorForPost(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshPosts,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _showLogoutConfirmation,
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            // Loading skeleton
            if (state is PostsLoading) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                itemCount: AppConstants.skeletonItemCount,
                itemBuilder: (context, index) => const PostSkeletonCard(),
              );
            }

            // Error state
            if (state is PostsError && state.previousPosts == null) {
              return AppErrorWidget(
                title: 'Erro ao carregar posts',
                message: state.message,
                onRetry: _loadInitialPosts,
              );
            }

            // Loaded state
            if (state is PostsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadAuthorsForPosts(state.posts);
              });

              return RefreshIndicator(
                onRefresh: () async => _refreshPosts(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppConstants.paddingS),
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    final author = _authorsCache[post.userId];
                    final isLoadingAuthor = _loadingAuthors.contains(post.userId);

                    return PostCardWidget(
                      post: post,
                      author: author,
                      isLoadingAuthor: author == null || isLoadingAuthor,
                      onTap: () => _navigateToPostDetail(post),
                      onAvatarTap: () => _navigateToProfile(post, author),
                    );
                  },
                ),
              );
            }

            // Loading more state
            if (state is PostsLoadingMore) {
              return RefreshIndicator(
                onRefresh: () async => _refreshPosts(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppConstants.paddingS),
                  itemCount: state.currentPosts.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.currentPosts.length) {
                      return const Padding(
                        padding: EdgeInsets.all(AppConstants.paddingS),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(AppConstants.primaryColorValue),
                            ),
                          ),
                        ),
                      );
                    }

                    final post = state.currentPosts[index];
                    final author = _authorsCache[post.userId];
                    final isLoadingAuthor = _loadingAuthors.contains(post.userId);

                    return PostCardWidget(
                      post: post,
                      author: author,
                      isLoadingAuthor: author == null || isLoadingAuthor,
                      onTap: () => _navigateToPostDetail(post),
                      onAvatarTap: () => _navigateToProfile(post, author),
                    );
                  },
                ),
              );
            }

            // Empty state
            return AppEmptyState(
              title: AppConstants.noPostsErrorMessage,
              message: '',
              onAction: _loadInitialPosts,
            );
          },
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LogoutBottomsheet(
          onLogout: _performLogout,
        );
      },
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      _navigateToLoginWithClearData();
    }
  }

  void _performLogout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  void _navigateToLoginWithClearData() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginPage(clearData: true),
      ),
          (route) => false,
    );
  }

  void _navigateToPostDetail(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailPage(post: post),
      ),
    );
  }

  void _navigateToProfile(PostModel post, UserPostModel? author) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(
          userId: post.userId.toString(),
          userName: author?.name ?? '${AppConstants.userFallbackPrefix}${post.userId}',
        ),
      ),
    );
  }
}