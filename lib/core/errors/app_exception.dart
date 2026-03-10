import 'app_error.dart';

class AppException implements Exception {
  const AppException(this.error);

  final AppError error;

  @override
  String toString() {
    return 'AppException(type: ${error.type.name}, '
        'statusCode: ${error.statusCode}, '
        'message: ${error.message})';
  }
}
