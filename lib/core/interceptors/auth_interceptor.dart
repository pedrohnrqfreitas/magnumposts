import 'package:dio/dio.dart';

import '../logging/app_loger.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.api('Making request to: ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.api('Response from ${response.requestOptions.uri}: ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'API Error: ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}