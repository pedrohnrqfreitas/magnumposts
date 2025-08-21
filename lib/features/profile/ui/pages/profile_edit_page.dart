import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/profile/models/profile_model.dart';
import '../../../../data/profile/models/params/update_profile_params.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileEditPage extends StatefulWidget {
  final ProfileModel profile;

  const ProfileEditPage({
    super.key,
    required this.profile,
  });

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
    _nameController.text = widget.profile.name;
    _ageController.text = widget.profile.age?.toString() ?? '';
    _interestsController.text = widget.profile.interests.join(', ');
  }

  void _handleProfileStateChange(BuildContext context, ProfileState state) {
    if (state is ProfileLoading || state is ProfileUpdating) {
      if (!_isLoading) {
        setState(() => _isLoading = true);
      }
    } else {
      if (_isLoading) {
        setState(() => _isLoading = false);
      }
      if (state is ProfileLoaded) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    }
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

    final params = UpdateProfileParams(
      userId: widget.profile.userId,
      name: name,
      age: age,
      interests: interests,
    );

    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(params: params),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.editProfileTitle),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: _handleProfileStateChange,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Column(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: AppConstants.iconSizeXxl,
                    color: Color(AppConstants.primaryColorValue),
                  ),
                  SizedBox(height: AppConstants.paddingS),
                  Text(
                    'Editar suas informações',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeL,
                      fontWeight: FontWeight.bold,
                      color: Color(AppConstants.textColorPrimaryValue),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppConstants.paddingXxs),
                  Text(
                    AppConstants.editProfileSubtitle,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXs,
                      color: Color(AppConstants.textColorTertiaryValue),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.dimenXs),

              // Formulário
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo Nome
                    TextFormField(
                      controller: _nameController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: AppConstants.nameFieldLabel,
                        hintText: AppConstants.nameFieldHint,
                        prefixIcon: Icon(Icons.person_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                          borderSide: BorderSide(
                            color: Color(AppConstants.borderColorLightValue),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                          borderSide: BorderSide(
                            color: Color(AppConstants.primaryColorValue),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(AppConstants.backgroundColorLightValue),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppConstants.nameRequiredMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingM),

                    // Campo Idade
                    TextFormField(
                      controller: _ageController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: AppConstants.ageFieldLabel,
                        hintText: AppConstants.ageFieldHint,
                        prefixIcon: Icon(Icons.cake_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                          borderSide: BorderSide(
                            color: Color(AppConstants.borderColorLightValue),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                          borderSide: BorderSide(
                            color: Color(AppConstants.primaryColorValue),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(AppConstants.backgroundColorLightValue),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final age = int.tryParse(value);
                          if (age == null || age < AppConstants.minAge || age > AppConstants.maxAge) {
                            return AppConstants.invalidAgeMessage;
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.paddingM),

                    // Campo Interesses
                    TextFormField(
                      controller: _interestsController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: AppConstants.interestsFieldLabel,
                        hintText: AppConstants.interestsFieldHint,
                        prefixIcon: Icon(Icons.favorite_rounded),
                        helperText: AppConstants.interestsFieldHelper,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                          borderSide: BorderSide(
                            color: Color(AppConstants.borderColorLightValue),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.borderRadius),
                          ),
                          borderSide: BorderSide(
                            color: Color(AppConstants.primaryColorValue),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(AppConstants.backgroundColorLightValue),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.dimenXs),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(AppConstants.primaryColorValue),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading) ...[
                        const SizedBox(
                          height: AppConstants.iconSizeS,
                          width: AppConstants.iconSizeS,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingXs),
                        const Text(
                          AppConstants.savingProfileMessage,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else ...[
                        const Icon(Icons.save_rounded),
                        const SizedBox(width: AppConstants.paddingXxs),
                        const Text(
                          AppConstants.saveProfileButtonText,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}