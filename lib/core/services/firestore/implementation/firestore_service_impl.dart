import 'package:cloud_firestore/cloud_firestore.dart';

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
    } catch (e) {
      throw Exception('Erro ao buscar documento: $e');
    }
  }

  @override
  Future<void> setDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      throw Exception('Erro ao salvar documento: $e');
    }
  }

  @override
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar documento: $e');
    }
  }

  @override
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar documento: $e');
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }
}