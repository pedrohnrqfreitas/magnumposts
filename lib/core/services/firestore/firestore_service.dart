import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreService {
  Future<Map<String, dynamic>?> getDocument(String collection, String docId);
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data);
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data);
  Future<void> deleteDocument(String collection, String docId);
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String collection, String docId);
}