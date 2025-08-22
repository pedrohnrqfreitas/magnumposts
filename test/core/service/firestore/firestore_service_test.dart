import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/services/firestore/implementation/firestore_service_impl.dart';
import 'package:magnumposts/core/errors/failure.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('FirestoreServiceImpl', () {
    late FirestoreServiceImpl firestoreService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDocument;
    late MockDocumentSnapshot mockSnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      mockSnapshot = MockDocumentSnapshot();
      firestoreService = FirestoreServiceImpl(firestore: mockFirestore);
    });

    group('getDocument', () {
      test('deve retornar dados do documento quando documento existir', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';
        final expectedData = {'name': 'Test User', 'email': 'test@test.com'};

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.data()).thenReturn(expectedData);

        // Act
        final result = await firestoreService.getDocument(collection, docId);

        // Assert
        expect(result, equals(expectedData));
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.get()).called(1);
      });

      test('deve retornar null quando documento não existir', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.data()).thenReturn(null);

        // Act
        final result = await firestoreService.getDocument(collection, docId);

        // Assert
        expect(result, isNull);
      });

      test('deve lançar Failure quando FirebaseException ocorrer', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.get()).thenThrow(FirebaseException(
          plugin: 'firestore',
          code: 'permission-denied',
        ));

        // Act & Assert
        expect(
              () => firestoreService.getDocument(collection, docId),
          throwsA(isA<Failure>()),
        );
      });
    });

    group('setDocument', () {
      test('deve salvar documento com sucesso', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';
        final data = {'name': 'Test User', 'email': 'test@test.com'};

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

      test('deve lançar Failure quando FirebaseException ocorrer', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';
        final data = {'name': 'Test User'};

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.set(data)).thenThrow(FirebaseException(
          plugin: 'firestore',
          code: 'permission-denied',
        ));

        // Act & Assert
        expect(
              () => firestoreService.setDocument(collection, docId, data),
          throwsA(isA<Failure>()),
        );
      });
    });

    group('updateDocument', () {
      test('deve atualizar documento com sucesso', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';
        final data = {'name': 'Updated User'};

        when(() => mockFirestore.collection(collection)).thenReturn(mockCollection);
        when(() => mockCollection.doc(docId)).thenReturn(mockDocument);
        when(() => mockDocument.update(data)).thenAnswer((_) async {});

        // Act
        await firestoreService.updateDocument(collection, docId, data);

        // Assert
        verify(() => mockFirestore.collection(collection)).called(1);
        verify(() => mockCollection.doc(docId)).called(1);
        verify(() => mockDocument.update(data)).called(1);
      });
    });

    group('deleteDocument', () {
      test('deve deletar documento com sucesso', () async {
        // Arrange
        const collection = 'users';
        const docId = 'user123';

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
    });
  });
}