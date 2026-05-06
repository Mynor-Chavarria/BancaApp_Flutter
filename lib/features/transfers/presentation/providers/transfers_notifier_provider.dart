import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/transfers_notifier.dart';
import '../state/transfers_state.dart';

final transfersNotifierProvider =
    NotifierProvider<TransfersNotifier, TransfersState>(TransfersNotifier.new);
