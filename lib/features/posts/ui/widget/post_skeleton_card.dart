import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_text.dart';
import '../../../../core/constants/app_constants.dart';

class PostSkeletonCard extends StatelessWidget {
  const PostSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.marginM),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingS),
        child: SkeletonLoader(
          isLoading: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSkeleton(),
              const SizedBox(height: AppConstants.paddingXs),
              _buildTitleSkeleton(),
              const SizedBox(height: AppConstants.paddingXxs),
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
                width: 100,
                height: AppConstants.fontSizeS,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
              ),
              const SizedBox(height: 4),
              SkeletonBox(
                width: 60,
                height: AppConstants.fontSizeXxs,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSkeleton() {
    return const SkeletonText(
      height: AppConstants.fontSizeS,
      lines: AppConstants.maxLinesTitle,
      spacing: 4,
    );
  }

  Widget _buildBodySkeleton() {
    return const SkeletonText(
      height: AppConstants.fontSizeXs,
      lines: AppConstants.maxLinesSubtitle,
      spacing: 4,
    );
  }
}