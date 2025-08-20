import 'package:flutter/material.dart';
import '../../../../data/posts/models/post_model.dart';
import '../../../profile/ui/pages/profile_detail_page.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  final VoidCallback? onAvatarTap;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildBody(),
              if (post.isBodyTruncated) ...[
                const SizedBox(height: 8),
                _buildSeeMoreButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _navigateToProfile(context),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF667eea),
            child: Text(
              'U${post.userId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuário ${post.userId}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Post #${post.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF718096),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      post.title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
        height: 1.3,
      ),
    );
  }

  Widget _buildBody() {
    return Text(
      post.truncatedBody,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF4A5568),
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSeeMoreButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF667eea),
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Ver mais',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    if (onAvatarTap != null) {
      onAvatarTap!();
    } else {
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
}