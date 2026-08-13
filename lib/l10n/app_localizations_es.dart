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
  String get createAccount => 'Crear cuenta';

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
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get orContinueWith => 'O continúa con';

  @override
  String get dashboard => 'Tablero';

  @override
  String get home => 'Inicio';

  @override
  String greeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get history => 'Historial';

  @override
  String get transfers => 'Transferencias';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

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
  String get creatingAccount => 'Creando cuenta...';

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get emailRequired => 'El correo electronico es obligatorio.';

  @override
  String get emailInvalid => 'Ingresa un correo electronico valido.';

  @override
  String get fullNameRequired => 'El nombre completo es obligatorio.';

  @override
  String get genderRequired => 'El genero es obligatorio.';

  @override
  String get usernameRequired => 'El usuario es obligatorio.';

  @override
  String get passwordRequired => 'La contraseña es obligatoria.';

  @override
  String get passwordMinLength => 'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get loginFailed => 'No fue posible iniciar sesión. Verifica tus credenciales.';

  @override
  String get registrationFailed => 'No fue posible crear la cuenta. Verifica los datos.';

  @override
  String get sessionExpired => 'Tu sesión expiró. Por favor inicia sesión nuevamente.';

  @override
  String get sessionEnded => 'Sesión finalizada';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get userId => 'ID de usuario';

  @override
  String get gender => 'Género';

  @override
  String get genderFemale => 'Femenino';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderOther => 'Otro';

  @override
  String get myAccounts => 'Mis productos';

  @override
  String get accountName => 'Nombre de la cuenta';

  @override
  String get accountMonetary => 'Cuenta Monetaria';

  @override
  String get accountSaving => 'Cuenta de Ahorro';

  @override
  String get creditCard => 'Tarjeta de Crédito';

  @override
  String get accountNumber => 'Número de cuenta';

  @override
  String get accountHolderName => 'Nombre asociado';

  @override
  String get amountInQuetzales => 'Monto en quetzales';

  @override
  String get noAccountsData => 'No hay cuentas disponibles.';

  @override
  String get payments => 'Pagos';

  @override
  String get paymentServicePayment => 'Pago de Servicios';

  @override
  String get paymentMobileRecharge => 'Recarga Móvil';

  @override
  String get accountHistory => 'Historial';

  @override
  String get allMovements => 'Todos';

  @override
  String get credit => 'Crédito';

  @override
  String get debit => 'Débito';

  @override
  String get filterFrom => 'Desde';

  @override
  String get filterTo => 'Hasta';

  @override
  String get noTransactions => 'Sin movimientos en este período.';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get loadMore => 'Cargar más';

  @override
  String get movementType => 'Tipo de movimiento';

  @override
  String get transferThirdParty => 'Terceros';

  @override
  String get transferOwn => 'Propias';

  @override
  String get transferACH => 'Otros Bancos ACH';

  @override
  String get transferInternational => 'Internacional';

  @override
  String get transferServicePayment => 'Pago de Servicios';

  @override
  String get transferMobileRecharge => 'Recarga Móvil';

  @override
  String get retry => 'Reintentar';

  @override
  String get noProfileData => 'No hay datos de perfil disponibles.';

  @override
  String get profileLoadFailed => 'No fue posible cargar tu perfil.';
}
