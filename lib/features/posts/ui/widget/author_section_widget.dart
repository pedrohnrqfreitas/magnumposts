import 'package:flutter/material.dart';

import '../../../../data/posts/models/post_model.dart';
import '../../../../data/posts/models/user_post_model.dart';

class AuthorSectionWidget extends StatelessWidget {
  final VoidCallback onClick;
  final UserPostModel? author;
  final PostModel post;
  final bool isLoadingAuthor;
  final String? authorError;

  const AuthorSectionWidget(
      {super.key,
      required this.onClick,
      required this.author,
      required this.post,
      required this.authorError,
      required this.isLoadingAuthor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
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
