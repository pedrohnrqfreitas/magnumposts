import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_text.dart';

class PostSkeletonCard extends StatelessWidget {
  const PostSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SkeletonLoader(
          isLoading: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSkeleton(),
              const SizedBox(height: 12),
              _buildTitleSkeleton(),
              const SizedBox(height: 8),
              _buildBodySkeleton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      children: [
        const SkeletonBox(
          width: 40,
          height: 40,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                width: 100,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              SkeletonBox(
                width: 60,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSkeleton() {
    return const SkeletonText(
      height: 16,
      lines: 2,
      spacing: 4,
    );
  }

  Widget _buildBodySkeleton() {
    return const SkeletonText(
      height: 14,
      lines: 3,
      spacing: 4,
    );
  }
}
