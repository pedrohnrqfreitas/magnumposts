import 'package:dio/dio.dart';
import '../../../constants/api_constants.dart';
import '../http_service.dart';

class DioHttpService implements HttpService {
  late final Dio _dio;

  DioHttpService({Dio? dio}) {
    _dio = dio ?? Dio();
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Interceptors para logging e tratamento de erros
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
  }

  InterceptorsWrapper _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.uri}');
        print('Headers: ${options.headers}');
        if (options.data != null) {
          print('Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('Error: ${error.message}');
        print('Request: ${error.requestOptions.uri}');
        handler.next(error);
      },
    );
  }

  InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionTimeout) {
          throw Exception('Tempo limite de conexão excedido');
        } else if (error.type == DioExceptionType.receiveTimeout) {
          throw Exception('Tempo limite de resposta excedido');
        } else if (error.type == DioExceptionType.connectionError) {
          throw Exception('Erro de conexão. Verifique sua internet');
        } else if (error.response?.statusCode == 404) {
          throw Exception('Recurso não encontrado');
        } else if (error.response?.statusCode == 500) {
          throw Exception('Erro interno do servidor');
        } else {
          throw Exception('Erro inesperado: ${error.message}');
        }
      },
    );
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  @override
  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  @override
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}