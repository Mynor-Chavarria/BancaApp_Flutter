import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/profile_notifier.dart';
import '../state/profile_state.dart';

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
