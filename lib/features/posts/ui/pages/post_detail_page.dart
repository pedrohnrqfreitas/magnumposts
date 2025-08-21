import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';
import '../../usecase/get_user_by_id_usecase.dart';
import '../widget/author_section_widget.dart';

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
          authorError = AppConstants.authorErrorMessage;
          isLoadingAuthor = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.postDetailTitle),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXl,
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.textColorPrimaryValue),
                height: AppConstants.lineHeightCompact,
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            AuthorSectionWidget(
              onClick: _navigateToProfile,
              author: author,
              post: widget.post,
              authorError: authorError,
              isLoadingAuthor: isLoadingAuthor,
            ),
            const SizedBox(height: AppConstants.paddingL),
            const Text(
              AppConstants.contentSectionTitle,
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.textColorPrimaryValue),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingS),
              decoration: BoxDecoration(
                color: const Color(AppConstants.backgroundColorCardValue),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: const Color(AppConstants.borderColorLightValue),
                ),
              ),
              child: Text(
                widget.post.body,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  color: Color(AppConstants.textColorSecondaryValue),
                  height: AppConstants.lineHeightLoose,
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
          userName: author?.name ?? '${AppConstants.userFallbackPrefix}${widget.post.userId}',
        ),
        settings: const RouteSettings(name: RouteNames.profile),
      ),
    );
  }
}