import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase(this.repository);

  final SettingsRepository repository;

  Future<SettingsEntity> call() {
    return repository.getSettings();
  }
}
