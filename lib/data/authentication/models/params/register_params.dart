class RegisterParams {
  final String email;
  final String password;
  final String confirmPassword;
  final String? displayName;
  final String? photoURL;

  RegisterParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.displayName,
    this.photoURL,
  });

  @override
  String toString() {
    return 'RegisterParams(email: $email, displayName: $displayName, password: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterParams &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.displayName == displayName &&
        other.photoURL == photoURL;
  }

  @override
  int get hashCode {
    return email.hashCode ^
    password.hashCode ^
    confirmPassword.hashCode ^
    displayName.hashCode ^
    photoURL.hashCode;
  }
}