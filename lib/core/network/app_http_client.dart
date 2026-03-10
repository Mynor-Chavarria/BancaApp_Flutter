import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_error.dart';
import '../errors/app_exception.dart';
import 'interceptors/auth_interceptor.dart';

class AppHttpClient {
  AppHttpClient._(this._dio);

  factory AppHttpClient({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
    TokenProvider? tokenProvider,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration sendTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
    bool enableLogging = true,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
          Headers.contentTypeHeader: Headers.jsonContentType,
          ...?defaultHeaders,
        },
      ),
    );

    if (tokenProvider != null) {
      dio.interceptors.add(AuthInterceptor(tokenProvider: tokenProvider));
    }

    if (enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (message) => debugPrint(message.toString()),
        ),
      );
    }

    return AppHttpClient._(dio);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _execute(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _execute<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      final response = await request();
      _validateStatusCode(response);
      return response;
    } on DioException catch (exception) {
      throw AppException(_mapDioException(exception));
    } on SocketException catch (exception) {
      throw AppException(
        AppError(
          type: AppErrorType.noConnection,
          message: 'Sin conexion a internet.',
          details: exception,
        ),
      );
    } on FormatException catch (exception) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: 'Respuesta invalida del servidor.',
          details: exception,
        ),
      );
    }
  }

  void _validateStatusCode<T>(Response<T> response) {
    final statusCode = response.statusCode;
    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw DioException.badResponse(
        statusCode: statusCode ?? 0,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }

  AppError _mapDioException(DioException exception) {
    if (exception.type == DioExceptionType.cancel) {
      return AppError(
        type: AppErrorType.canceled,
        message: 'Solicitud cancelada.',
        details: exception,
      );
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return AppError(
        type: AppErrorType.timeout,
        message: 'La solicitud excedio el tiempo limite.',
        details: exception,
      );
    }

    if (exception.type == DioExceptionType.connectionError ||
        exception.error is SocketException) {
      return AppError(
        type: AppErrorType.noConnection,
        message: 'Sin conexion a internet.',
        details: exception,
      );
    }

    final response = exception.response;
    final payloadMessage = _extractMessage(response?.data);

    return AppError.fromStatusCode(
      response?.statusCode,
      message: payloadMessage,
      details: response?.data ?? exception,
    );
  }

  String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    return null;
  }
}
