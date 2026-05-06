import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/local/dashboard_local_datasource.dart';
import '../../data/datasources/local/dashboard_local_datasource_impl.dart';
import '../../data/datasources/remote/dashboard_remote_datasource.dart';
import '../../data/datasources/remote/dashboard_remote_datasource_impl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((
  ref,
) {
  return DashboardRemoteDataSourceImpl(ref.watch(authHttpClientProvider));
});

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>((
  ref,
) {
  return const DashboardLocalDataSourceImpl();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    localDataSource: ref.watch(dashboardLocalDataSourceProvider),
    remoteDataSource: ref.watch(dashboardRemoteDataSourceProvider),
  );
});

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(ref.watch(dashboardRepositoryProvider));
});
