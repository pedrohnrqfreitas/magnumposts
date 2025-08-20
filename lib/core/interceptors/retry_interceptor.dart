import 'package:dio/dio.dart';
import '../logging/app_loger.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retry_count'] ?? 0;

      if (retryCount < maxRetries) {
        AppLogger.warning('Retrying request (${retryCount + 1}/$maxRetries): ${err.requestOptions.uri}');

        err.requestOptions.extra['retry_count'] = retryCount + 1;

        await Future.delayed(retryDelay);

        try {
          final dio = Dio();
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
        } catch (e) {
          super.onError(err, handler);
        }
      } else {
        AppLogger.error('Max retries exceeded for: ${err.requestOptions.uri}');
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}