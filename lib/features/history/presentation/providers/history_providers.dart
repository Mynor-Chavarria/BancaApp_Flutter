import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/history_local_datasource.dart';
import '../../data/datasources/local/history_local_datasource_impl.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/get_history_usecase.dart';

final historyLocalDataSourceProvider = Provider<HistoryLocalDataSource>(
  (_) => const HistoryLocalDataSourceImpl(),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepositoryImpl(
    localDataSource: ref.watch(historyLocalDataSourceProvider),
  ),
);

final getAccountTransactionsUseCaseProvider = Provider<
  GetAccountTransactionsUseCase
>((ref) => GetAccountTransactionsUseCase(ref.watch(historyRepositoryProvider)));
