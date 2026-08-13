import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/local/dashboard_local_datasource.dart';
import '../../data/datasources/local/dashboard_local_datasource_impl.dart';
import '../../data/datasources/remote/dashboard_firestore_datasource.dart';
import '../../data/datasources/remote/dashboard_firestore_datasource_impl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>((
  ref,
) {
  return const DashboardLocalDataSourceImpl();
});

final dashboardFirestoreDataSourceProvider =
    Provider<DashboardFirestoreDataSource>((ref) {
      return DashboardFirestoreDataSourceImpl(
        ref.watch(firebaseFirestoreProvider),
      );
    });

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    localDataSource: ref.watch(dashboardLocalDataSourceProvider),
    firestoreDataSource: ref.watch(dashboardFirestoreDataSourceProvider),
    sessionProvider: () => ref.read(authNotifierProvider).session,
  );
});

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(ref.watch(dashboardRepositoryProvider));
});
