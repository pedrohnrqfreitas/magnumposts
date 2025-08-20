import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../errors/firebase_error_handler.dart';
import '../firestore_service.dart';

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreServiceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>?> getDocument(String collection, String docId) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.data();
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    }
  }

  @override
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    }
  }

  @override
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    }
  }

  @override
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String collection, String docId) {
    try {
      return _firestore.collection(collection).doc(docId).snapshots();
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleFirestoreError(e);
    }
  }
}