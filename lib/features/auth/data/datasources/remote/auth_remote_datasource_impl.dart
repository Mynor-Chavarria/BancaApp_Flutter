import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/network/network.dart';
import '../../models/auth_session_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<AuthSessionModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: username.trim(),
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        throw const AppException(
          AppError(
            type: AppErrorType.unknown,
            message: 'No fue posible obtener el usuario autenticado.',
          ),
        );
      }

      return _sessionFromUser(user, fallbackEmail: username.trim());
    } on FirebaseAuthException catch (error) {
      throw AppException(
        AppError(
          type: _errorTypeFromFirebaseCode(error.code),
          message: _messageFromFirebaseCode(error.code),
          details: error,
        ),
      );
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: 'No fue posible leer los datos del usuario.',
          details: error,
        ),
      );
    }
  }

  @override
  Future<AuthSessionModel> register({
    required String fullName,
    required String email,
    required String gender,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        throw const AppException(
          AppError(
            type: AppErrorType.unknown,
            message: 'No fue posible crear el usuario autenticado.',
          ),
        );
      }

      final normalizedFullName = fullName.trim();
      final normalizedEmail = email.trim();
      final normalizedGender = gender.trim();

      await user.updateDisplayName(normalizedFullName);
      await user.getIdToken(true);
      try {
        await _usersCollection.doc(user.uid).set({
          'uid': user.uid,
          'fullName': normalizedFullName,
          'email': normalizedEmail,
          'gender': normalizedGender,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException {
        await _deleteUserAfterFailedProfileSave(user);
        rethrow;
      }

      return _sessionFromUser(
        user,
        fallbackEmail: normalizedEmail,
        fallbackFullName: normalizedFullName,
        fallbackGender: normalizedGender,
      );
    } on FirebaseAuthException catch (error) {
      throw AppException(
        AppError(
          type: _errorTypeFromFirebaseCode(error.code),
          message: _messageFromFirebaseCode(error.code),
          details: error,
        ),
      );
    } on FirebaseException catch (error) {
      throw AppException(
        AppError(
          type: AppErrorType.unknown,
          message: _messageFromFirestoreError(error),
          details: error,
        ),
      );
    }
  }

  @override
  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  Future<void> _deleteUserAfterFailedProfileSave(User user) async {
    try {
      await user.delete();
    } catch (_) {
      await _firebaseAuth.signOut();
    }
  }

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<AuthSessionModel> _sessionFromUser(
    User user, {
    String? fallbackEmail,
    String? fallbackFullName,
    String? fallbackGender,
  }) async {
    final accessToken = await user.getIdToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw const AppException(
        AppError(
          type: AppErrorType.unknown,
          message: 'No fue posible obtener el token de Firebase.',
        ),
      );
    }

    final profile = await _loadUserProfile(user.uid);
    final email =
        _stringValue(profile['email']) ?? user.email ?? fallbackEmail ?? '';
    final fullName =
        _stringValue(profile['fullName']) ??
        fallbackFullName ??
        user.displayName;
    final gender = _stringValue(profile['gender']) ?? fallbackGender;
    final resolvedUsername =
        fullName == null || fullName.trim().isEmpty ? email : fullName.trim();

    return AuthSessionModel(
      uid: user.uid,
      id: _stableIdFromUid(user.uid),
      username: resolvedUsername,
      email: email,
      accessToken: accessToken,
      refreshToken: user.refreshToken ?? '',
      firstName: fullName?.trim(),
      gender: gender?.trim(),
      image: user.photoURL,
    );
  }

  Future<Map<String, dynamic>> _loadUserProfile(String uid) async {
    final snapshot = await _usersCollection.doc(uid).get();
    return snapshot.data() ?? const {};
  }

  String? _stringValue(Object? value) {
    if (value is! String) {
      return null;
    }

    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  int _stableIdFromUid(String uid) {
    return uid.codeUnits.fold<int>(
      0,
      (hash, codeUnit) => (hash * 31 + codeUnit) & 0x7fffffff,
    );
  }

  AppErrorType _errorTypeFromFirebaseCode(String code) {
    return switch (code) {
      'invalid-email' => AppErrorType.badRequest,
      'user-disabled' => AppErrorType.forbidden,
      'email-already-in-use' => AppErrorType.conflict,
      'weak-password' => AppErrorType.badRequest,
      'operation-not-allowed' => AppErrorType.forbidden,
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => AppErrorType.unauthorized,
      'too-many-requests' => AppErrorType.timeout,
      'network-request-failed' => AppErrorType.noConnection,
      _ => AppErrorType.unknown,
    };
  }

  String _messageFromFirebaseCode(String code) {
    return switch (code) {
      'invalid-email' => 'El correo electronico no es valido.',
      'user-disabled' => 'El usuario esta deshabilitado.',
      'email-already-in-use' => 'Ya existe una cuenta con este correo.',
      'weak-password' => 'La contrasena es demasiado debil.',
      'operation-not-allowed' =>
        'El proveedor de correo y contrasena no esta habilitado.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Correo o contrasena incorrectos.',
      'too-many-requests' => 'Demasiados intentos. Intenta de nuevo mas tarde.',
      'network-request-failed' => 'Sin conexion a internet.',
      _ => 'No fue posible iniciar sesion con Firebase.',
    };
  }

  String _messageFromFirestoreError(FirebaseException error) {
    final fallback = switch (error.code) {
      'permission-denied' =>
        'Firestore rechazo guardar el usuario. Revisa y despliega las reglas.',
      'unauthenticated' =>
        'Firestore no recibio la sesion autenticada. Cierra la app e intenta de nuevo.',
      'failed-precondition' =>
        'Firestore no esta listo para guardar datos. Revisa que la base de datos este creada en modo Firestore nativo.',
      'not-found' =>
        'Firestore no esta configurado. Crea la base de datos en Firebase Console.',
      'unavailable' =>
        'Firestore no esta disponible. Revisa tu conexion e intenta de nuevo.',
      _ => 'No fue posible guardar los datos del usuario en Firestore.',
    };

    final detail = error.message?.trim();
    if (detail == null || detail.isEmpty) {
      return '$fallback (${error.code})';
    }

    return '$fallback (${error.code}: $detail)';
  }
}
