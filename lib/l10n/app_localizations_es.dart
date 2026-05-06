// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Banca App';

  @override
  String get balance => 'Saldo';

  @override
  String get transactions => 'Transacciones';

  @override
  String get welcome => '¡Bienvenido!';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get username => 'Usuario';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get notUser => '¿No tienes un usuario?';

  @override
  String get registerNow => 'Regístrate ahora';

  @override
  String get orContinueWith => 'O continúa con';

  @override
  String get dashboard => 'Tablero';

  @override
  String get history => 'Historial';

  @override
  String get transfers => 'Transferencias';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmDescription => '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get loggingIn => 'Iniciando sesión...';

  @override
  String get loggingOut => 'Cerrando sesión...';

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get usernameRequired => 'El usuario es obligatorio.';

  @override
  String get passwordRequired => 'La contraseña es obligatoria.';

  @override
  String get passwordMinLength => 'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get loginFailed => 'No fue posible iniciar sesión. Verifica tus credenciales.';

  @override
  String get sessionExpired => 'Tu sesión expiró. Por favor inicia sesión nuevamente.';
}
