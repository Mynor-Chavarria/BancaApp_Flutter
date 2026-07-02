import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/payments_notifier.dart';
import '../state/payments_state.dart';

final paymentsNotifierProvider =
    NotifierProvider<PaymentsNotifier, PaymentsState>(PaymentsNotifier.new);
