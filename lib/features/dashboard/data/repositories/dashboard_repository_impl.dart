import '../../../auth/domain/entities/auth_session.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/local/dashboard_local_datasource.dart';
import '../datasources/remote/dashboard_firestore_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({
    required DashboardLocalDataSource localDataSource,
    required DashboardFirestoreDataSource firestoreDataSource,
    required AuthSession? Function() sessionProvider,
  }) : _localDataSource = localDataSource,
       _firestoreDataSource = firestoreDataSource,
       _sessionProvider = sessionProvider;

  final DashboardLocalDataSource _localDataSource;
  final DashboardFirestoreDataSource _firestoreDataSource;
  final AuthSession? Function() _sessionProvider;

  @override
  Future<List<DashboardEntity>> getMyAccounts() async {
    final session = _sessionProvider();
    if (session == null) {
      return [];
    }

    var accounts = await _firestoreDataSource.getAccounts(uid: session.uid);
    if (accounts.isEmpty) {
      final seedAccounts = await _localDataSource.getMyAccounts();
      await _firestoreDataSource.seedAccounts(
        uid: session.uid,
        accounts: seedAccounts
            .map(
              (account) => account.copyWith(
                accountHolderName: _resolveAccountHolderName(session),
              ),
            )
            .toList(growable: false),
      );
      accounts = await _firestoreDataSource.getAccounts(uid: session.uid);
    }

    final accountHolderName = _resolveAccountHolderName(session);

    return accounts
        .map(
          (account) =>
              account
                  .copyWith(
                    accountHolderName:
                        accountHolderName.isEmpty
                            ? account.accountHolderName
                            : accountHolderName,
                  )
                  .toEntity(),
        )
        .toList(growable: false);
  }

  String _resolveAccountHolderName(AuthSession? session) {
    if (session == null) {
      return '';
    }

    final fullName = [session.firstName, session.lastName]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' ');

    if (fullName.isNotEmpty) {
      return fullName;
    }

    if (session.username.trim().isNotEmpty) {
      return session.username.trim();
    }

    return session.email.trim();
  }
}
