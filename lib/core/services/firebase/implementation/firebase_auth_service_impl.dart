import 'package:firebase_auth/firebase_auth.dart';
import '../../../errors/firebase_error_handler.dart';
import '../firebase_auth_service.dart';

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthServiceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    }
  }

  @override
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(photoURL);
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleAuthError(e);
    }
  }
}