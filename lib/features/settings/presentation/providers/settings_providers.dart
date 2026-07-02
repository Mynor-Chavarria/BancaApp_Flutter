import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/remote/settings_remote_datasource.dart';
import '../../data/datasources/remote/settings_remote_datasource_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((
  ref,
) {
  return SettingsRemoteDataSourceImpl(ref.watch(authHttpClientProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    remoteDataSource: ref.watch(settingsRemoteDataSourceProvider),
  );
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(settingsRepositoryProvider));
});
