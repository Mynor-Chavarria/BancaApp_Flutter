import '../../../auth/domain/entities/auth_session.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({
    required AuthSession? Function() sessionProvider,
  }) : _sessionProvider = sessionProvider;

  final AuthSession? Function() _sessionProvider;

  @override
  Future<SettingsEntity> getSettings() async {
    return const SettingsEntity(notificationsEnabled: true, languageCode: 'en');
  }

  @override
  Future<UserProfile> getCurrentUser() async {
    final session = _sessionProvider();
    if (session == null) {
      throw StateError('No hay una sesion activa.');
    }

    return UserProfile(
      id: session.userId,
      username: session.username,
      email: session.email,
      firstName: session.firstName,
      lastName: session.lastName,
      gender: session.gender,
      image: session.image,
    );
  }
}
