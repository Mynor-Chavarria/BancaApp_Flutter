import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/local/dashboard_local_datasource.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required DashboardLocalDataSource localDataSource,
    required DashboardRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final DashboardLocalDataSource _localDataSource;
  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<List<DashboardEntity>> getMyAccounts() async {
    final accounts = await _localDataSource.getMyAccounts();
    final user = await _remoteDataSource.getCurrentUser();

    return accounts
        .map(
          (account) =>
              account
                  .copyWith(
                    accountHolderName:
                        user.fullName.isEmpty
                            ? account.accountHolderName
                            : user.fullName,
                  )
                  .toEntity(),
        )
        .toList(growable: false);
  }
}
