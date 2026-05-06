import 'package:dio/dio.dart';

typedef OnSessionExpired = Future<void> Function();

class SessionExpiredInterceptor extends Interceptor {
  SessionExpiredInterceptor({required this.onSessionExpired});

  final OnSessionExpired onSessionExpired;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await onSessionExpired();
    }
    handler.next(err);
  }
}
