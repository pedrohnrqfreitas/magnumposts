import 'package:flutter/material.dart';

class PostLoadingCardWidget extends StatelessWidget {
  const PostLoadingCardWidget({super.key});

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
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      children: [
        _buildSkeleton(width: 40, height: 40, isCircular: true),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeleton(width: 100, height: 16),
              const SizedBox(height: 4),
              _buildSkeleton(width: 60, height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeleton(width: double.infinity, height: 16),
        const SizedBox(height: 4),
        _buildSkeleton(width: 200, height: 16),
      ],
    );
  }

  Widget _buildBodySkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeleton(width: double.infinity, height: 14),
        const SizedBox(height: 4),
        _buildSkeleton(width: double.infinity, height: 14),
        const SizedBox(height: 4),
        _buildSkeleton(width: 150, height: 14),
      ],
    );
  }

  Widget _buildSkeleton({
    required double width,
    required double height,
    bool isCircular = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: isCircular
            ? BorderRadius.circular(height / 2)
            : BorderRadius.circular(4),
      ),
    );
  }
}