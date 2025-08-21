import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnumposts/features/posts/ui/widget/author_section_widget.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';
import '../../usecase/get_user_by_id_usecase.dart';
import '../../../../core/constants/app_constants.dart';

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
      appBar: AppBar(
        title: const Text('Detalhes do Post'),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.dimenXxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppConstants.dimenXxs),
            AuthorSectionWidget(
              onClick: _navigateToProfile,
              author: author,
              post: widget.post,
              authorError: authorError,
              isLoadingAuthor: isLoadingAuthor,
            ),
            const SizedBox(height: AppConstants.dimenXxs),
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
              padding: const EdgeInsets.all(AppConstants.dimenXxxs),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
            const SizedBox(height: AppConstants.dimenXs),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(
          userId: widget.post.userId.toString(),
          userName: author?.name ?? 'Usuário ${widget.post.userId}',
        ),
        settings: const RouteSettings(name: RouteNames.profile),
      ),
    );
  }
}