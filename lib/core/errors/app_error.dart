enum AppErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  unprocessableEntity,
  timeout,
  noConnection,
  server,
  canceled,
  unknown,
}

class AppError {
  const AppError({
    required this.type,
    required this.message,
    this.statusCode,
    this.details,
  });

  factory AppError.fromStatusCode(
    int? statusCode, {
    String? message,
    Object? details,
  }) {
    final resolvedType = switch (statusCode) {
      400 => AppErrorType.badRequest,
      401 => AppErrorType.unauthorized,
      403 => AppErrorType.forbidden,
      404 => AppErrorType.notFound,
      409 => AppErrorType.conflict,
      422 => AppErrorType.unprocessableEntity,
      _ when statusCode != null && statusCode >= 500 => AppErrorType.server,
      _ => AppErrorType.unknown,
    };

    final resolvedMessage =
        message?.trim().isNotEmpty == true
            ? message!.trim()
            : _defaultMessageForType(resolvedType);

    return AppError(
      type: resolvedType,
      message: resolvedMessage,
      statusCode: statusCode,
      details: details,
    );
  }

  final AppErrorType type;
  final String message;
  final int? statusCode;
  final Object? details;

  static String _defaultMessageForType(AppErrorType type) {
    return switch (type) {
      AppErrorType.badRequest => 'Solicitud invalida.',
      AppErrorType.unauthorized => 'No autorizado.',
      AppErrorType.forbidden => 'Acceso denegado.',
      AppErrorType.notFound => 'Recurso no encontrado.',
      AppErrorType.conflict => 'Conflicto en la solicitud.',
      AppErrorType.unprocessableEntity => 'Datos no procesables.',
      AppErrorType.timeout => 'La solicitud excedio el tiempo limite.',
      AppErrorType.noConnection => 'Sin conexion a internet.',
      AppErrorType.server => 'Error interno del servidor.',
      AppErrorType.canceled => 'Solicitud cancelada.',
      AppErrorType.unknown => 'Error inesperado.',
    };
  }
}
