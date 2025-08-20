class UserResponseDTO {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool? emailVerified;
  final String? lastSignInTime;
  final String? creationTime;

  UserResponseDTO({
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified,
    this.lastSignInTime,
    this.creationTime,
  });

  factory UserResponseDTO.fromMap(Map<String, dynamic> map) {
    return UserResponseDTO(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      emailVerified: map['emailVerified'],
      lastSignInTime: map['lastSignInTime'],
      creationTime: map['creationTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'lastSignInTime': lastSignInTime,
      'creationTime': creationTime,
    };
  }
}