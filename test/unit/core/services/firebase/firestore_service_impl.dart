import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:magnumposts/core/services/firestore/implementation/firestore_service_impl.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('FirestoreServiceImpl', () {
    late FirestoreServiceImpl firestoreService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDocument;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() {
      // Configura mocks
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      mockDocumentSnapshot = MockDocumentSnapshot();

      // Cria o service com o mock
      firestoreService = FirestoreServiceImpl(firestore: mockFirestore);

      // Setup fallbacks
      setupMocktailFallbacks();
    });

    group('getDocument', () {
      test('should return document data when document exists', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';
        final documentData = MockData.profileFirestoreData;

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.data()).thenReturn(documentData);

        // Act
        final result = await firestoreService.getDocument(collection, docId);

        // Assert
        expect(result, equals(documentData));
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.get()).called(1);
      });

      test('should return null when document does not exist', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'non_existent_doc';

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockDocumentSnapshot.data()).thenReturn(null);

        // Act
        final result = await firestoreService.getDocument(collection, docId);

        // Assert
        expect(result, isNull);
      });

      test('should throw exception when Firestore error occurs', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';

        final firestoreException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.get()).thenThrow(firestoreException);

        // Act & Assert
        expect(
              () => firestoreService.getDocument(collection, docId),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('setDocument', () {
      test('should set document successfully', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';
        final data = MockData.profileFirestoreData;

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.set(data)).thenAnswer((_) async {});

        // Act
        await firestoreService.setDocument(collection, docId, data);

        // Assert
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.set(data)).called(1);
      });

      test('should throw exception when set fails', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';
        final data = MockData.profileFirestoreData;

        final firestoreException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.set(data)).thenThrow(firestoreException);

        // Act & Assert
        expect(
              () => firestoreService.setDocument(collection, docId, data),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('updateDocument', () {
      test('should update document successfully', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';
        final updateData = {
          'name': 'Updated Name',
          'age': 30,
          'updatedAt': DateTime.now().toIso8601String(),
        };

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.update(updateData)).thenAnswer((_) async {});

        // Act
        await firestoreService.updateDocument(collection, docId, updateData);

        // Assert
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.update(updateData)).called(1);
      });

      test('should throw exception when update fails', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';
        final updateData = {'name': 'Updated Name'};

        final firestoreException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'not-found',
          message: 'Document not found',
        );

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.update(updateData)).thenThrow(firestoreException);

        // Act & Assert
        expect(
              () => firestoreService.updateDocument(collection, docId, updateData),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('deleteDocument', () {
      test('should delete document successfully', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.delete()).thenAnswer((_) async {});

        // Act
        await firestoreService.deleteDocument(collection, docId);

        // Assert
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.delete()).called(1);
      });

      test('should throw exception when delete fails', () async {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';

        final firestoreException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.delete()).thenThrow(firestoreException);

        // Act & Assert
        expect(
              () => firestoreService.deleteDocument(collection, docId),
          throwsA(isA<dynamic>()),
        );
      });
    });

    group('streamDocument', () {
      test('should return stream of document snapshots', () {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';
        final snapshotStream = Stream<DocumentSnapshot<Map<String, dynamic>>>.fromIterable([
          mockDocumentSnapshot
        ]);

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.snapshots()).thenAnswer((_) => snapshotStream);

        // Act
        final result = firestoreService.streamDocument(collection, docId);

        // Assert
        expect(result, equals(snapshotStream));
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.snapshots()).called(1);
      });

      test('should throw exception when stream fails', () {
        // Arrange
        const collection = 'profiles';
        const docId = 'test_doc_id';

        final firestoreException = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        );

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.snapshots()).thenThrow(firestoreException);

        // Act & Assert
        expect(
              () => firestoreService.streamDocument(collection, docId),
          throwsA(isA<dynamic>()),
        );
      });
    });
  });
}