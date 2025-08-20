// lib/features/posts/ui/pages/post_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';
import '../../usecase/get_user_by_id_usecase.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  const PostDetailPage({
    super.key,
    required this.post,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  UserPostModel? author;
  bool isLoadingAuthor = true;
  String? authorError;

  @override
  void initState() {
    super.initState();
    _loadAuthor();
  }

  void _loadAuthor() async {
    try {
      final getUserUseCase = context.read<GetUserByIdUseCase>();
      final result = await getUserUseCase(widget.post.userId);

      result.fold(
            (failure) {
          if (mounted) {
            setState(() {
              authorError = failure.message;
              isLoadingAuthor = false;
            });
          }
        },
            (user) {
          if (mounted) {
            setState(() {
              author = user;
              isLoadingAuthor = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          authorError = 'Erro ao carregar autor';
          isLoadingAuthor = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Detalhes do Post'),
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 24),
          _buildAuthorSection(),
          const SizedBox(height: 24),
          _buildBodyContent(),
          const SizedBox(height: 32),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.post.title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
        height: 1.3,
      ),
    );
  }

  Widget _buildAuthorSection() {
    return GestureDetector(
      onTap: () => _navigateToProfile(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF667eea),
              child: Text(
                _getAuthorInitials(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoadingAuthor)
                    const Text(
                      'Carregando autor...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF718096),
                      ),
                    )
                  else if (authorError != null)
                    Text(
                      authorError!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    )
                  else if (author != null) ...[
                      Text(
                        author!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${author!.username}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF718096),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conteúdo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            widget.post.body,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A5568),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF667eea),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_rounded),
            SizedBox(width: 8),
            Text(
              'Voltar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAuthorInitials() {
    if (author?.name != null) {
      final nameParts = author!.name.split(' ');
      if (nameParts.length >= 2) {
        return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else if (nameParts.isNotEmpty) {
        return nameParts[0][0].toUpperCase();
      }
    }
    return 'U${widget.post.userId}';
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(
          userId: widget.post.userId.toString(),
          userName: author?.name ?? 'Usuário ${widget.post.userId}',
        ),
      ),
    );
  }
}