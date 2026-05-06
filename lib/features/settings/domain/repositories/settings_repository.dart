import '../entities/settings_entity.dart';
import '../entities/user_profile.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<UserProfile> getCurrentUser();
}
