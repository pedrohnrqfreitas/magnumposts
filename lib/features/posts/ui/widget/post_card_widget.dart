import 'package:flutter/material.dart';

import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/skeleton_text.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final UserPostModel? author;
  final bool isLoadingAuthor;
  final VoidCallback onTap;
  final VoidCallback? onAvatarTap;

  const PostCardWidget({
    super.key,
    required this.post,
    this.author,
    this.isLoadingAuthor = false,
    required this.onTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return isLoadingAuthor ? _buildSkeletonCard() : _buildNormalCard();
  }

  Widget _buildSkeletonCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.marginM),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: null,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingS),
          child: SkeletonLoader(
            isLoading: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SkeletonBox(
                      width: AppConstants.avatarSizeS,
                      height: AppConstants.avatarSizeS,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.avatarRadiusM),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingXs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(
                            width: 120,
                            height: AppConstants.fontSizeXs,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                          ),
                          const SizedBox(height: 4),
                          SkeletonBox(
                            width: 80,
                            height: AppConstants.fontSizeXxs,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                          ),
                        ],
                      ),
                    ),
                    SkeletonBox(
                      width: 50,
                      height: AppConstants.fontSizeXxs,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingXs),
                const SkeletonText(
                  height: AppConstants.fontSizeS,
                  lines: AppConstants.maxLinesTitle,
                  spacing: 4,
                ),
                const SizedBox(height: AppConstants.paddingXxs),
                const SkeletonText(
                  height: AppConstants.fontSizeXs,
                  lines: AppConstants.maxLinesSubtitle,
                  spacing: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.marginM),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: author != null ? onAvatarTap : null,
                    child: Container(
                      width: AppConstants.avatarSizeS,
                      height: AppConstants.avatarSizeS,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(AppConstants.primaryColorValue),
                      ),
                      child: Center(
                        child: Text(
                          _getAuthorInitials(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.fontSizeS,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingXs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author?.name ?? '${AppConstants.userFallbackPrefix}${post.userId}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXs,
                            fontWeight: FontWeight.w600,
                            color: Color(AppConstants.textColorPrimaryValue),
                          ),
                          maxLines: AppConstants.maxLinesSingle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (author != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '@${author!.username}',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeXxs,
                              color: Color(AppConstants.textColorTertiaryValue),
                            ),
                            maxLines: AppConstants.maxLinesSingle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '${AppConstants.postIdPrefix}${post.id}',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeXxs,
                      color: Color(AppConstants.textColorTertiaryValue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingXs),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeS,
                  fontWeight: FontWeight.w600,
                  color: Color(AppConstants.textColorPrimaryValue),
                  height: AppConstants.lineHeightCompact,
                ),
              ),
              const SizedBox(height: AppConstants.paddingXxs),
              Text(
                post.truncatedBody,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeXs,
                  color: Color(AppConstants.textColorSecondaryValue),
                  height: AppConstants.lineHeightNormal,
                ),
                maxLines: AppConstants.maxLinesSubtitle,
                overflow: TextOverflow.ellipsis,
              ),
              if (post.isBodyTruncated) ...[
                const SizedBox(height: AppConstants.paddingXxs),
                _buildSeeMoreButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(AppConstants.primaryColorValue),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          AppConstants.seeMoreText,
          style: TextStyle(
            fontSize: AppConstants.fontSizeXs,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getAuthorInitials() {
    if (author?.name != null && author!.name.isNotEmpty) {
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