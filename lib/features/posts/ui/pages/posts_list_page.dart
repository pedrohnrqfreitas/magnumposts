import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/ui/bloc/auth_bloc.dart';
import '../../../authentication/ui/bloc/auth_event.dart';
import '../../../authentication/ui/bloc/auth_state.dart';
import '../../../authentication/ui/pages/login_page.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';
import '../../../../data/posts/models/post_model.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';

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
          _scrollController.position.maxScrollExtent * 0.8) {
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
    context.read<PostsBloc>().add(const PostRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Magnum Posts'),
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _refreshPosts,
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => _performLogout(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading) {
          return _buildSkeletonLoading();
        } else if (state is PostsError && state.previousPosts == null) {
          return _buildErrorWidget(state.message);
        } else if (state is PostsLoaded) {
          return _buildPostsList(state);
        } else if (state is PostsLoadingMore) {
          return _buildPostsList(
            PostsLoaded(posts: state.currentPosts),
            showLoadingMore: true,
          );
        }

        return _buildEmptyWidget();
      },
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6, // Show 6 skeleton cards
      itemBuilder: (context, index) => const PostSkeletonCard(),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Ops! Algo deu errado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInitialPosts,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
            ),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Color(0xFF718096),
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum post encontrado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(PostsLoaded state, {bool showLoadingMore = false}) {
    return RefreshIndicator(
      onRefresh: () async => _refreshPosts(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.posts.length + (showLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.posts.length) {
            return _buildLoadingMoreWidget();
          }

          final post = state.posts[index];
          return PostCardWidget(
            post: post,
            onTap: () => _navigateToPostDetail(post),
            onAvatarTap: () => _navigateToProfile(post),
          );
        },
      ),
    );
  }

  Widget _buildLoadingMoreWidget() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthUnauthenticated) {
      _navigateToLogin();
    }
  }

  void _performLogout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
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

  void _navigateToProfile(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(
          userId: post.userId.toString(),
          userName: 'Usuário ${post.userId}',
        ),
      ),
    );
  }
}