import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/ui/bloc/auth_bloc.dart';
import '../../../authentication/ui/bloc/auth_event.dart';
import '../../../authentication/ui/bloc/auth_state.dart';
import '../../../authentication/ui/pages/login_page.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';
import '../../usecase/get_user_by_id_usecase.dart';
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

  // Cache para autores dos posts
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
    // Limpar cache de autores ao refreshar
    _authorsCache.clear();
    _loadingAuthors.clear();
    context.read<PostsBloc>().add(const PostRefreshRequested());
  }

  // Método para carregar autor de um post específico
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

  // Método para carregar autores em lote
  void _loadAuthorsForPosts(List<PostModel> posts) {
    final uniqueUserIds = posts.map((post) => post.userId).toSet();

    for (final userId in uniqueUserIds) {
      _loadAuthorForPost(userId);
    }
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
          onPressed: _showLogoutConfirmation,
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
          // Carregar autores quando posts são carregados
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadAuthorsForPosts(state.posts);
          });

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
      itemCount: 6,
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
          final author = _authorsCache[post.userId];
          final isLoadingAuthor = _loadingAuthors.contains(post.userId);

          return PostCardWidget(
            post: post,
            author: author,
            isLoadingAuthor: isLoadingAuthor,
            onTap: () => _navigateToPostDetail(post),
            onAvatarTap: () => _navigateToProfile(post, author),
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

  /// Exibe diálogo de confirmação antes do logout
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Tem certeza que deseja sair?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
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

  /// Navega para login garantindo que os dados sejam limpos
  void _navigateToLoginWithClearData() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginPage(clearData: true),
      ),
          (route) => false, // Remove todas as rotas anteriores
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
          userName: author?.name ?? 'Usuário ${post.userId}',
        ),
      ),
    );
  }
}