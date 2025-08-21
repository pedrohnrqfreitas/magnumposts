import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnumposts/features/profile/ui/pages/profile_creat_page.dart';
import 'package:magnumposts/features/profile/ui/pages/profile_edit_page.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/profile/models/profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileDetailPage extends StatefulWidget {
  final String userId;
  final String? userName;

  const ProfileDetailPage({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    context.read<ProfileBloc>().add(
      ProfileLoadRequested(userId: widget.userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? AppConstants.profileDetailTitle),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () => _navigateToEditProfile(state.profile),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(AppConstants.primaryColorValue),
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingS),
                  Text(
                    AppConstants.loadingProfileMessage,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeS,
                      color: Color(AppConstants.textColorTertiaryValue),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileError) {
            return AppErrorWidget(
              title: 'Erro ao carregar Perfil',
              message: state.message,
              onRetry: _loadProfile,
            );
          }

          if (state is ProfileNotFound) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_off_rounded,
                      size: AppConstants.iconSizeXxl,
                      color: Color(AppConstants.textColorTertiaryValue),
                    ),
                    const SizedBox(height: AppConstants.paddingS),
                    const Text(
                      AppConstants.profileNotFoundTitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.bold,
                        color: Color(AppConstants.textColorPrimaryValue),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXxs),
                    const Text(
                      AppConstants.profileNotFoundMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXs,
                        color: Color(AppConstants.textColorTertiaryValue),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingL),
                    ElevatedButton(
                      onPressed: _navigateToCreateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppConstants.primaryColorValue),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                      child: const Text(AppConstants.createProfileButtonText),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                children: [
                  // Header do perfil
                  Column(
                    children: [
                      SizedBox(
                        width: AppConstants.profileImageSize,
                        height: AppConstants.profileImageSize,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profile.avatarUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeXl,
                          fontWeight: FontWeight.bold,
                          color: Color(AppConstants.textColorPrimaryValue),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.paddingXxs),
                      Text(
                        '${AppConstants.memberSinceText}${profile.memberSince}',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeXs,
                          color: Color(AppConstants.textColorTertiaryValue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.dimenXs),

                  // Estatísticas
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
                            const Icon(
                              Icons.article_rounded,
                              size: AppConstants.iconSizeM,
                              color: Color(AppConstants.primaryColorValue),
                            ),
                            const SizedBox(height: AppConstants.paddingXxs),
                            Text(
                              '${profile.postsCount}',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeL,
                                fontWeight: FontWeight.bold,
                                color: Color(AppConstants.textColorPrimaryValue),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              AppConstants.postsStatsLabel,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXxs,
                                color: Color(AppConstants.textColorTertiaryValue),
                              ),
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
                            const Icon(
                              Icons.cake_rounded,
                              size: AppConstants.iconSizeM,
                              color: Color(AppConstants.primaryColorValue),
                            ),
                            const SizedBox(height: AppConstants.paddingXxs),
                            Text(
                              profile.age?.toString() ?? AppConstants.ageNotAvailable,
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeL,
                                fontWeight: FontWeight.bold,
                                color: Color(AppConstants.textColorPrimaryValue),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              AppConstants.ageStatsLabel,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXxs,
                                color: Color(AppConstants.textColorTertiaryValue),
                              ),
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
                            const Icon(
                              Icons.favorite_rounded,
                              size: AppConstants.iconSizeM,
                              color: Color(AppConstants.primaryColorValue),
                            ),
                            const SizedBox(height: AppConstants.paddingXxs),
                            Text(
                              '${profile.interests.length}',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeL,
                                fontWeight: FontWeight.bold,
                                color: Color(AppConstants.textColorPrimaryValue),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              AppConstants.interestsStatsLabel,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeXxs,
                                color: Color(AppConstants.textColorTertiaryValue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.dimenXs),

                  // Seção de Interesses
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
                        const Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              size: AppConstants.iconSizeS,
                              color: Color(AppConstants.primaryColorValue),
                            ),
                            SizedBox(width: AppConstants.paddingXxs),
                            Text(
                              AppConstants.interestsStatsLabel,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeS,
                                fontWeight: FontWeight.w600,
                                color: Color(AppConstants.textColorPrimaryValue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.paddingXs),
                        Text(
                          profile.formattedInterests,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXs,
                            color: Color(AppConstants.textColorSecondaryValue),
                            height: AppConstants.lineHeightRelaxed,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Seção de Idade (se disponível)
                  if (profile.age != null) ...[
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
                          const Row(
                            children: [
                              Icon(
                                Icons.cake_rounded,
                                size: AppConstants.iconSizeS,
                                color: Color(AppConstants.primaryColorValue),
                              ),
                              SizedBox(width: AppConstants.paddingXxs),
                              Text(
                                AppConstants.ageStatsLabel,
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeS,
                                  fontWeight: FontWeight.w600,
                                  color: Color(AppConstants.textColorPrimaryValue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingXs),
                          Text(
                            '${profile.age}${AppConstants.ageUnitText}',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeXs,
                              color: Color(AppConstants.textColorSecondaryValue),
                              height: AppConstants.lineHeightRelaxed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return AppEmptyState(
            title: AppConstants.noPostsErrorMessage,
            message: '',
            onAction: _loadProfile,
          );
        },
      ),
    );
  }

  void _navigateToEditProfile(ProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileEditPage(profile: profile),
      ),
    ).then((_) {
      _loadProfile();
    });
  }

  void _navigateToCreateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileCreatePage(
          userId: widget.userId,
          userName: widget.userName,
        ),
      ),
    ).then((_) {
      Navigator.of(context).pop();
    });
  }
}