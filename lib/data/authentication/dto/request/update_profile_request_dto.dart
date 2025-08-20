class UpdateProfileRequestDTO {
  final String? displayName;
  final String? photoURL;

  UpdateProfileRequestDTO({
    this.displayName,
    this.photoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (photoURL != null) 'photoURL': photoURL,
    };
  }
}