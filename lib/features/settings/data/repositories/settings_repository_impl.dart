import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/remote/settings_remote_datasource.dart';
import '../models/user_profile_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({
    required SettingsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final SettingsRemoteDataSource _remoteDataSource;

  @override
  Future<SettingsEntity> getSettings() async {
    return const SettingsEntity(notificationsEnabled: true, languageCode: 'en');
  }

  @override
  Future<UserProfile> getCurrentUser() async {
    final profile = await _remoteDataSource.getCurrentUser();
    return profile.toEntity();
  }
}
