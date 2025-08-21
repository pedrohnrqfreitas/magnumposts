import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';

class AuthorSectionWidget extends StatelessWidget {
  final VoidCallback onClick;
  final UserPostModel? author;
  final PostModel post;
  final bool isLoadingAuthor;
  final String? authorError;

  const AuthorSectionWidget({
    super.key,
    required this.onClick,
    required this.author,
    required this.post,
    required this.authorError,
    required this.isLoadingAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingS),
        decoration: BoxDecoration(
          color: const Color(AppConstants.backgroundColorLightValue),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: const Color(AppConstants.borderColorLightValue),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppConstants.avatarRadiusL,
              backgroundColor: const Color(AppConstants.primaryColorValue),
              child: Text(
                _getAuthorInitials(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoadingAuthor)
                    const Text(
                      AppConstants.loadingAuthorMessage,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: Color(AppConstants.textColorTertiaryValue),
                      ),
                    )
                  else if (authorError != null)
                    Text(
                      authorError!,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeS,
                        color: Colors.red,
                      ),
                    )
                  else if (author != null) ...[
                      Text(
                        author!.name,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeS,
                          fontWeight: FontWeight.w600,
                          color: Color(AppConstants.textColorPrimaryValue),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${author!.username}',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeXs,
                          color: Color(AppConstants.textColorTertiaryValue),
                        ),
                      ),
                    ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppConstants.iconSizeXs,
              color: Color(AppConstants.textColorTertiaryValue),
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
    return 'U${post.userId}';
  }
}