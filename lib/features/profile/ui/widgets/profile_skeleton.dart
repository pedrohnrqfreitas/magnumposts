import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_text.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SkeletonLoader(
        isLoading: true,
        child: Column(
          children: [
            _buildProfileHeaderSkeleton(),
            const SizedBox(height: 32),
            _buildProfileStatsSkeleton(),
            const SizedBox(height: 32),
            _buildProfileInfoSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderSkeleton() {
    return Column(
      children: [
        const SkeletonBox(
          width: 120,
          height: 120,
          borderRadius: BorderRadius.all(Radius.circular(60)),
        ),
        const SizedBox(height: 16),
        SkeletonBox(
          width: 200,
          height: 24,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        SkeletonBox(
          width: 120,
          height: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildProfileStatsSkeleton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItemSkeleton(),
          _buildStatDivider(),
          _buildStatItemSkeleton(),
          _buildStatDivider(),
          _buildStatItemSkeleton(),
        ],
      ),
    );
  }

  Widget _buildStatItemSkeleton() {
    return Column(
      children: [
        SkeletonBox(
          width: 24,
          height: 24,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        SkeletonBox(
          width: 30,
          height: 20,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        SkeletonBox(
          width: 50,
          height: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey[300],
    );
  }

  Widget _buildProfileInfoSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSectionSkeleton(),
        const SizedBox(height: 24),
        _buildInfoSectionSkeleton(),
      ],
    );
  }

  Widget _buildInfoSectionSkeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 8),
              SkeletonBox(
                width: 80,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonText(
            height: 14,
            lines: 2,
            spacing: 4,
          ),
        ],
      ),
    );
  }
}