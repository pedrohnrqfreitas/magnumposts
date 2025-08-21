import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_text.dart';
import '../../../../core/constants/app_constants.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: SkeletonLoader(
        isLoading: true,
        child: Column(
          children: [
            // Header do perfil skeleton
            Column(
              children: [
                const SkeletonBox(
                  width: AppConstants.profileImageSize,
                  height: AppConstants.profileImageSize,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConstants.profileImageRadius),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                SkeletonBox(
                  width: 200,
                  height: AppConstants.fontSizeXl,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                ),
                const SizedBox(height: AppConstants.paddingXxs),
                SkeletonBox(
                  width: 120,
                  height: AppConstants.fontSizeXs,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.dimenXs),
            // Stats skeleton
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: const Color(AppConstants.backgroundColorLightValue),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
                border: Border.all(
                  color: const Color(AppConstants.borderColorLightValue),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SkeletonBox(
                        width: AppConstants.iconSizeM,
                        height: AppConstants.iconSizeM,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                      const SizedBox(height: AppConstants.paddingXxs),
                      SkeletonBox(
                        width: 30,
                        height: AppConstants.fontSizeL,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                      const SizedBox(height: 4),
                      SkeletonBox(
                        width: 50,
                        height: AppConstants.fontSizeXxs,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                    ],
                  ),
                  Container(
                    width: AppConstants.statsDividerWidth,
                    height: AppConstants.statsContainerHeight,
                    color: const Color(AppConstants.borderColorLightValue),
                  ),
                  Column(
                    children: [
                      SkeletonBox(
                        width: AppConstants.iconSizeM,
                        height: AppConstants.iconSizeM,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                      const SizedBox(height: AppConstants.paddingXxs),
                      SkeletonBox(
                        width: 30,
                        height: AppConstants.fontSizeL,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                      const SizedBox(height: 4),
                      SkeletonBox(
                        width: 50,
                        height: AppConstants.fontSizeXxs,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                    ],
                  ),
                  Container(
                    width: AppConstants.statsDividerWidth,
                    height: AppConstants.statsContainerHeight,
                    color: const Color(AppConstants.borderColorLightValue),
                  ),
                  Column(
                    children: [
                      SkeletonBox(
                        width: AppConstants.iconSizeM,
                        height: AppConstants.iconSizeM,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                      const SizedBox(height: AppConstants.paddingXxs),
                      SkeletonBox(
                        width: 30,
                        height: AppConstants.fontSizeL,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                      const SizedBox(height: 4),
                      SkeletonBox(
                        width: 50,
                        height: AppConstants.fontSizeXxs,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.dimenXs),

            // Info sections skeleton
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonBox(
                            width: AppConstants.iconSizeS,
                            height: AppConstants.iconSizeS,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                          ),
                          const SizedBox(width: AppConstants.paddingXxs),
                          SkeletonBox(
                            width: 80,
                            height: AppConstants.fontSizeS,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingXs),
                      const SkeletonText(
                        height: AppConstants.fontSizeXs,
                        lines: 2,
                        spacing: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonBox(
                            width: AppConstants.iconSizeS,
                            height: AppConstants.iconSizeS,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                          ),
                          const SizedBox(width: AppConstants.paddingXxs),
                          SkeletonBox(
                            width: 80,
                            height: AppConstants.fontSizeS,
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingXs),
                      const SkeletonText(
                        height: AppConstants.fontSizeXs,
                        lines: 2,
                        spacing: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}