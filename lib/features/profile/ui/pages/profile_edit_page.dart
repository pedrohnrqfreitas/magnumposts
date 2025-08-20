// lib/features/profile/ui/pages/profile_edit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/profile/models/profile_model.dart';
import '../../../../data/profile/models/params/create_profile_params.dart';
import '../../../../data/profile/models/params/update_profile_params.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileEditPage extends StatefulWidget {
  final ProfileModel? profile;
  final String? userId;
  final String? userName;

  const ProfileEditPage({
    super.key,
    this.profile,
    this.userId,
    this.userName,
  });

  bool get isEditing => profile != null;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _interestsController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  void _initializeFields() {
    if (widget.profile != null) {
      _nameController.text = widget.profile!.name;
      _ageController.text = widget.profile!.age?.toString() ?? '';
      _interestsController.text = widget.profile!.interests.join(', ');
    } else if (widget.userName != null) {
      _nameController.text = widget.userName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: _handleProfileStateChange,
        child: Stack(
          children: [
            _buildBody(),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.isEditing ? 'Editar Perfil' : 'Criar Perfil'),
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isEditing ? 'Salvando alterações...' : 'Criando perfil...',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Por favor, aguarde',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          widget.isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
          size: 64,
          color: const Color(0xFF667eea),
        ),
        const SizedBox(height: 16),
        Text(
          widget.isEditing ? 'Editar suas informações' : 'Criar seu perfil',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.isEditing
              ? 'Atualize suas informações pessoais'
              : 'Preencha suas informações básicas',
          style: const TextStyle(
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
        onPressed: _isLoading ? null : _saveProfile,
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
            ] else ...[
              Icon(widget.isEditing ? Icons.save_rounded : Icons.add_rounded),
              const SizedBox(width: 8),
            ],
            Text(
              _isLoading
                  ? (widget.isEditing ? 'Salvando...' : 'Criando...')
                  : (widget.isEditing ? 'Salvar alterações' : 'Criar perfil'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleProfileStateChange(BuildContext context, ProfileState state) {
    if (state is ProfileLoading || state is ProfileUpdating) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      if (state is ProfileError) {
        _showErrorDialog(state.message);
      } else if (state is ProfileLoaded && !widget.isEditing) {
        _showSuccessAndClose('Perfil criado com sucesso!');
      } else if (state is ProfileUpdateSuccess) {
        _showSuccessAndClose(state.message);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessAndClose(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();
    final interestsText = _interestsController.text.trim();

    final age = ageText.isNotEmpty ? int.tryParse(ageText) : null;
    final interests = interestsText.isNotEmpty
        ? interestsText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : <String>[];

    if (widget.isEditing) {
      // Atualizar perfil existente
      final params = UpdateProfileParams(
        userId: widget.profile!.userId,
        name: name,
        age: age,
        interests: interests,
      );

      context.read<ProfileBloc>().add(
        ProfileUpdateRequested(params: params),
      );
    } else {
      // Criar novo perfil
      final userId = widget.userId ?? '';
      if (userId.isEmpty) {
        _showErrorDialog('ID do usuário não encontrado');
        return;
      }

      final params = CreateProfileParams(
        userId: userId,
        name: name,
        age: age,
        interests: interests,
      );

      context.read<ProfileBloc>().add(
        ProfileCreateRequested(params: params),
      );
    }
  }
}