import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthService {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> updateDisplayName(String displayName);
  Future<void> updatePhotoURL(String photoURL);
}