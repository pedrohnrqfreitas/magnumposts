import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/profile/models/params/create_profile_params.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/succesProfileBottomSheet.dart';

class ProfileCreatePage extends StatefulWidget {
  final String userId;
  final String? userName;

  const ProfileCreatePage({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<ProfileCreatePage> createState() => _ProfileCreatePageState();
}

class _ProfileCreatePageState extends State<ProfileCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _interestsController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userName != null) {
      _nameController.text = widget.userName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  void _handleProfileStateChange(BuildContext context, ProfileState state) {
    if (state is ProfileLoading || state is ProfileCreating) {
      if (!_isLoading) {
        setState(() => _isLoading = true);
      }
    } else {
      if (_isLoading) {
        setState(() => _isLoading = false);
      }
      _showSuccessBottomSheet();
    }
  }

  void _createProfile() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();
    final interestsText = _interestsController.text.trim();
    final age = ageText.isNotEmpty ? int.tryParse(ageText) : null;
    final interests = interestsText.isNotEmpty
        ? interestsText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];
    final params = CreateProfileParams(
      userId: widget.userId,
      name: name,
      age: age,
      interests: interests,
    );
    context.read<ProfileBloc>().add(
          ProfileCreateRequested(params: params),
        );
  }

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isDismissible: false,
      builder: (BuildContext context) {
        return const SuccessProfileBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Perfil'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: _handleProfileStateChange,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildForm(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Icon(
          Icons.person_add_rounded,
          size: 64,
          color: Color(0xFF667eea),
        ),
        SizedBox(height: 16),
        Text(
          'Criar seu perfil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Preencha suas informações básicas',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField(),
          const SizedBox(height: 20),
          _buildAgeField(),
          const SizedBox(height: 20),
          _buildInterestsField(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      enabled: !_isLoading,
      decoration: const InputDecoration(
        labelText: 'Nome completo',
        hintText: 'Digite seu nome completo',
        prefixIcon: Icon(Icons.person_rounded),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nome é obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      enabled: !_isLoading,
      decoration: const InputDecoration(
        labelText: 'Idade (opcional)',
        hintText: 'Digite sua idade',
        prefixIcon: Icon(Icons.cake_rounded),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final age = int.tryParse(value);
          if (age == null || age < 1 || age > 120) {
            return 'Digite uma idade válida (1-120)';
          }
        }
        return null;
      },
    );
  }

  Widget _buildInterestsField() {
    return TextFormField(
      controller: _interestsController,
      enabled: !_isLoading,
      decoration: const InputDecoration(
        labelText: 'Interesses (opcional)',
        hintText: 'Ex: tecnologia, música, esportes',
        prefixIcon: Icon(Icons.favorite_rounded),
        helperText: 'Separe os interesses por vírgula',
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF667eea),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Criando...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              const Icon(Icons.add_rounded),
              const SizedBox(width: 8),
              const Text(
                'Criar perfil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
