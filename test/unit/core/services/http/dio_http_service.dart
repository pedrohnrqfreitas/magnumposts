import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/core/services/http/implementation/dio_http_service.dart';
import '../../../../helpers/test_helpers.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('DioHttpService', () {
    late DioHttpService httpService;
    late MockDio mockDio;

    setUp(() {
      // Configura mocks
      mockDio = MockDio();

      // Cria o service com o mock
      httpService = DioHttpService(dio: mockDio);

      // Setup fallbacks
      setupMocktailFallbacks();

      // Registra fallback para RequestOptions
      registerFallbackValue(RequestOptions(path: ''));
    });

    group('get', () {
      test('should return response when GET request succeeds', () async {
        // Arrange
        const path = '/posts';
        final queryParameters = {'_page': 1, '_limit': 10};
        final responseData = MockData.postsJsonResponse;
        final mockResponse = createMockDioResponse(data: responseData);

        when(() => mockDio.get(path, queryParameters: queryParameters))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await httpService.get(path, queryParameters: queryParameters);

        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.get(path, queryParameters: queryParameters)).called(1);
      });

      test('should return response when GET request succeeds without query parameters', () async {
        // Arrange
        const path = '/posts/1';
        final responseData = MockData.postJsonResponse;
        final mockResponse = createMockDioResponse(data: responseData);

        when(() => mockDio.get(path, queryParameters: null))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await httpService.get(path);

        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.get(path, queryParameters: null)).called(1);
      });

      test('should throw exception when connection timeout occurs', () async {
        // Arrange
        const path = '/posts';

        final dioException = DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        when(() => mockDio.get(path, queryParameters: null))
            .thenThrow(dioException);

        // Act & Assert
        expect(
              () => httpService.get(path),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when receive timeout occurs', () async {
        // Arrange
        const path = '/posts';

        final dioException = DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        );

        when(() => mockDio.get(path, queryParameters: null))
            .thenThrow(dioException);

        // Act & Assert
        expect(
              () => httpService.get(path),
          throwsA(predicate((e) =>
          e is Exception &&
              e.toString().contains('Tempo limite de resposta excedido')
          )),
        );
      });

      test('should throw exception when connection error occurs', () async {
        // Arrange
        const path = '/posts';

        final dioException = DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionError,
          message: 'Connection error',
        );

        when(() => mockDio.get(path, queryParameters: null))
            .thenThrow(dioException);

        // Act & Assert
        expect(
              () => httpService.get(path),
          throwsA(predicate((e) =>
          e is Exception &&
              e.toString().contains('Erro de conexão')
          )),
        );
      });

      test('should throw exception when 404 error occurs', () async {
        // Arrange
        const path = '/posts/999';

        final dioException = DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(
            requestOptions: RequestOptions(path: path),
            statusCode: 404,
            statusMessage: 'Not Found',
          ),
          type: DioExceptionType.badResponse,
        );

        when(() => mockDio.get(path, queryParameters: null))
            .thenThrow(dioException);

        // Act & Assert
        expect(
              () => httpService.get(path),
          throwsA(predicate((e) =>
          e is Exception &&
              e.toString().contains('Recurso não encontrado')
          )),
        );
      });

      test('should throw exception when 500 error occurs', () async {
        // Arrange
        const path = '/posts';

        final dioException = DioException(
          requestOptions: RequestOptions(path: path),
          response: Response(
            requestOptions: RequestOptions(path: path),
            statusCode: 500,
            statusMessage: 'Internal Server Error',
          ),
          type: DioExceptionType.badResponse,
        );

        when(() => mockDio.get(path, queryParameters: null))
            .thenThrow(dioException);

        // Act & Assert
        expect(
              () => httpService.get(path),
          throwsA(predicate((e) =>
          e is Exception &&
              e.toString().contains('Erro interno do servidor')
          )),
        );
      });
    });

    group('post', () {
      test('should return response when POST request succeeds', () async {
        // Arrange
        const path = '/posts';
        final requestData = {
          'title': 'New Post',
          'body': 'Post content',
          'userId': 1,
        };
        final responseData = {...requestData, 'id': 101};
        final mockResponse = createMockDioResponse(data: responseData, statusCode: 201);

        when(() => mockDio.post(path, data: requestData))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await httpService.post(path, data: requestData);

        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.post(path, data: requestData)).called(1);
      });

      test('should handle POST request without data', () async {
        // Arrange
        const path = '/posts';
        final mockResponse = createMockDioResponse(data: {}, statusCode: 201);

        when(() => mockDio.post(path, data: null))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await httpService.post(path);

        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.post(path, data: null)).called(1);
      });
    });

    group('put', () {
      test('should return response when PUT request succeeds', () async {
        // Arrange
        const path = '/posts/1';
        final requestData = {
          'title': 'Updated Post',
          'body': 'Updated content',
          'userId': 1,
        };
        final responseData = {...requestData, 'id': 1};
        final mockResponse = createMockDioResponse(data: responseData);

        when(() => mockDio.put(path, data: requestData))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await httpService.put(path, data: requestData);

        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.put(path, data: requestData)).called(1);
      });
    });

    group('delete', () {
      test('should return response when DELETE request succeeds', () async {
        // Arrange
        const path = '/posts/1';
        final mockResponse = createMockDioResponse(data: {}, statusCode: 200);

        when(() => mockDio.delete(path))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await httpService.delete(path);

        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.delete(path)).called(1);
      });
    });
  });
}