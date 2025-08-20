import 'package:firebase_auth/firebase_auth.dart';
import '../dto/response/user_response_dto.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final DateTime? lastSignIn;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
    this.lastSignIn,
    required this.createdAt,
  });

  factory UserModel.fromDTO(UserResponseDTO? dto) {
    return UserModel(
      uid: dto?.uid ?? '',
      email: dto?.email ?? '',
      displayName: dto?.displayName,
      photoURL: dto?.photoURL,
      emailVerified: dto?.emailVerified ?? false,
      lastSignIn: dto?.lastSignInTime != null
          ? DateTime.tryParse(dto!.lastSignInTime!)
          : null,
      createdAt: dto?.creationTime != null
          ? DateTime.tryParse(dto!.creationTime!) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified,
      lastSignIn: firebaseUser.metadata.lastSignInTime,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  UserResponseDTO toDTO() {
    return UserResponseDTO(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      emailVerified: emailVerified,
      lastSignInTime: lastSignIn?.toIso8601String(),
      creationTime: createdAt.toIso8601String(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}