import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnumposts/features/profile/ui/pages/profile_creat_page.dart';
import 'package:magnumposts/features/profile/ui/pages/profile_edit_page.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
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
        title: Text(widget.userName ?? 'Perfil do Usuário'),
        backgroundColor: const Color(0xFF667eea),
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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return switch (state) {
            ProfileLoading() => _buildLoadingWidget(),
            ProfileError() => AppErrorWidget(
              title: 'Erro ao carregar Perfil',
              message: state.message,
              onRetry: _loadProfile,
            ),
            ProfileNotFound() => _buildNotFoundWidget(),
            ProfileLoaded() => _buildProfileContent(state.profile),
            _ => AppEmptyState(
              title: 'Nenhum post encontrado',
              message: '',
              onAction: _loadProfile,
            ),
          };
        },
      ),
    );
  }


  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
          ),
          SizedBox(height: 16),
          Text(
            'Carregando perfil...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off_rounded,
              size: 64,
              color: Color(0xFF718096),
            ),
            const SizedBox(height: 16),
            const Text(
              'Perfil não encontrado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Este usuário ainda não possui um perfil criado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _navigateToCreateProfile,
              child: const Text('Criar perfil'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileContent(ProfileModel profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profile.avatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Membro há ${profile.memberSince}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Posts', '${profile.postsCount}', Icons.article_rounded),
                _buildStatDivider(),
                _buildStatItem(
                  'Idade',
                  profile.age?.toString() ?? 'N/A',
                  Icons.cake_rounded,
                ),
                _buildStatDivider(),
                _buildStatItem(
                  'Interesses',
                  '${profile.interests.length}',
                  Icons.favorite_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(
                'Interesses',
                profile.formattedInterests,
                Icons.favorite_rounded,
              ),
              if (profile.age != null) ...[
                const SizedBox(height: 24),
                _buildInfoSection(
                  'Idade',
                  '${profile.age} anos',
                  Icons.cake_rounded,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFF667eea),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
          ),
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

  Widget _buildInfoSection(String title, String content, IconData icon) {
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
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF667eea),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5568),
              height: 1.5,
            ),
          ),
        ],
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