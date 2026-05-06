import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_profile.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    String? errorMessage,
    UserProfile? profile,
  }) = _ProfileState;
}
