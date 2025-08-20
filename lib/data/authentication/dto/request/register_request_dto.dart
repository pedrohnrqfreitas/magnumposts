class RegisterRequestDTO {
  final String email;
  final String password;
  final String? displayName;

  RegisterRequestDTO({
    required this.email,
    required this.password,
    this.displayName,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      if (displayName != null) 'displayName': displayName,
    };
  }
}