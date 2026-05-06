import '../../domain/entities/transfer_entity.dart';

class TransfersState {
  const TransfersState({
    this.isLoading = false,
    this.errorMessage,
    this.transferTypes = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<TransferTypeEntity> transferTypes;

  TransfersState copyWith({
    bool? isLoading,
    Object? errorMessage = _noChange,
    List<TransferTypeEntity>? transferTypes,
  }) {
    return TransfersState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          identical(errorMessage, _noChange)
              ? this.errorMessage
              : errorMessage as String?,
      transferTypes: transferTypes ?? this.transferTypes,
    );
  }
}

const _noChange = Object();
