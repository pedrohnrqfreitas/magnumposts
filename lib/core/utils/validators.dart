import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Senha deve ter pelo menos ${AppConstants.minPasswordLength} caracteres';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Senha deve ter no máximo ${AppConstants.maxPasswordLength} caracteres';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != password) {
      return 'Senhas não coincidem';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value, {bool isRequired = true}) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'Nome é obrigatório';
    }

    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 2) {
        return 'Nome deve ter pelo menos 2 caracteres';
      }

      if (value.length > AppConstants.maxProfileNameLength) {
        return 'Nome deve ter no máximo ${AppConstants.maxProfileNameLength} caracteres';
      }
    }

    return null;
  }

  // Age validation
  static String? validateAge(String? value, {bool isRequired = false}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Idade é obrigatória';
    }

    if (value != null && value.isNotEmpty) {
      final age = int.tryParse(value);
      if (age == null) {
        return 'Digite uma idade válida';
      }

      if (age < AppConstants.minAge || age > AppConstants.maxAge) {
        return 'Idade deve estar entre ${AppConstants.minAge} e ${AppConstants.maxAge} anos';
      }
    }

    return null;
  }

  // Interests validation
  static String? validateInterests(String? value) {
    if (value != null && value.isNotEmpty) {
      final interests = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      if (interests.length > AppConstants.maxInterestsCount) {
        return 'Máximo de ${AppConstants.maxInterestsCount} interesses permitidos';
      }

      for (final interest in interests) {
        if (interest.length > AppConstants.maxInterestLength) {
          return 'Cada interesse deve ter no máximo ${AppConstants.maxInterestLength} caracteres';
        }
      }
    }

    return null;
  }
}