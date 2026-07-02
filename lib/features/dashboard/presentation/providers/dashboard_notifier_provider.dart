import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/dashboard_notifier.dart';
import '../state/dashboard_state.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);
