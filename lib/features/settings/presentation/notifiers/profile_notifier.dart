import 'package:banca_app/core/errors/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../providers/settings_providers.dart';
import '../state/profile_state.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  GetCurrentUserUseCase get _getCurrentUserUseCase =>
      ref.read(getCurrentUserUseCaseProvider);

  Future<void> loadProfile() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final profile = await _getCurrentUserUseCase();
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        profile: profile,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.error.message,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: null);
    }
  }
}
