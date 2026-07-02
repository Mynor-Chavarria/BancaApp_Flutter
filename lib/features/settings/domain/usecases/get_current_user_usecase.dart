import '../entities/user_profile.dart';
import '../repositories/settings_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final SettingsRepository _repository;

  Future<UserProfile> call() {
    return _repository.getCurrentUser();
  }
}
