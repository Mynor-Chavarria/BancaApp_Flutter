import '../../models/user_profile_model.dart';

abstract class SettingsRemoteDataSource {
  Future<UserProfileModel> getCurrentUser();
}
