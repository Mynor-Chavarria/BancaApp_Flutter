import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/local/history_local_datasource.dart';
import '../../data/datasources/local/history_local_datasource_impl.dart';
import '../../data/datasources/remote/history_firestore_datasource.dart';
import '../../data/datasources/remote/history_firestore_datasource_impl.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/get_history_usecase.dart';

final historyLocalDataSourceProvider = Provider<HistoryLocalDataSource>(
  (_) => const HistoryLocalDataSourceImpl(),
);

final historyFirestoreDataSourceProvider = Provider<HistoryFirestoreDataSource>(
  (ref) => HistoryFirestoreDataSourceImpl(ref.watch(firebaseFirestoreProvider)),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepositoryImpl(
    localDataSource: ref.watch(historyLocalDataSourceProvider),
    firestoreDataSource: ref.watch(historyFirestoreDataSourceProvider),
    sessionProvider: () => ref.read(authNotifierProvider).session,
  ),
);

final getAccountTransactionsUseCaseProvider = Provider<
  GetAccountTransactionsUseCase
>((ref) => GetAccountTransactionsUseCase(ref.watch(historyRepositoryProvider)));

final getAccountTransactionsPageUseCaseProvider =
    Provider<GetAccountTransactionsPageUseCase>(
      (ref) => GetAccountTransactionsPageUseCase(
        ref.watch(historyRepositoryProvider),
      ),
    );
