import 'package:dio/dio.dart';

typedef TokenProvider = Future<String?> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenProvider,
    this.headerName = 'Authorization',
  });

  final TokenProvider tokenProvider;
  final String headerName;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    if (token != null && token.trim().isNotEmpty) {
      options.headers[headerName] = 'Bearer $token';
    }

    handler.next(options);
  }
}
