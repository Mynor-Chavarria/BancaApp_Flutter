import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/account_history_notifier.dart';
import '../state/account_history_state.dart';

final accountHistoryNotifierProvider =
    NotifierProvider<AccountHistoryNotifier, AccountHistoryState>(
      () => AccountHistoryNotifier(),
    );
