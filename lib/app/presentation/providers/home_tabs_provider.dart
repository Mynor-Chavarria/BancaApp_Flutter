import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabsNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setCurrentIndex(int index) {
    if (state == index) {
      return;
    }
    state = index;
  }
}

final homeTabsProvider = NotifierProvider<HomeTabsNotifier, int>(
  HomeTabsNotifier.new,
);
