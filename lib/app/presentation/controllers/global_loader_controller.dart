import 'package:flutter/foundation.dart';

class GlobalLoaderState {
  const GlobalLoaderState({required this.isVisible, this.message});

  final bool isVisible;
  final String? message;

  GlobalLoaderState copyWith({bool? isVisible, String? message}) {
    return GlobalLoaderState(
      isVisible: isVisible ?? this.isVisible,
      message: message ?? this.message,
    );
  }
}

class GlobalLoaderController {
  GlobalLoaderController._();

  static final GlobalLoaderController instance = GlobalLoaderController._();

  final ValueNotifier<GlobalLoaderState> state = ValueNotifier(
    const GlobalLoaderState(isVisible: false),
  );

  void setLoading(bool isLoading, {String? message}) {
    if (!isLoading) {
      state.value = const GlobalLoaderState(isVisible: false);
      return;
    }

    state.value = GlobalLoaderState(isVisible: true, message: message);
  }

  void show({String? message}) {
    setLoading(true, message: message);
  }

  void hide() {
    setLoading(false);
  }
}
