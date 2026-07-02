import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transfer_entity.dart';
import '../providers/transfers_notifier_provider.dart';

class TransfersView extends ConsumerStatefulWidget {
  const TransfersView({super.key});

  @override
  ConsumerState<TransfersView> createState() => _TransfersViewState();
}

class _TransfersViewState extends ConsumerState<TransfersView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(transfersNotifierProvider.notifier).loadTransferTypes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(transfersNotifierProvider);

    if (state.isLoading && state.transferTypes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      key: const ValueKey('transfers'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.transfers,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: state.transferTypes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final type = state.transferTypes[index];
                return _TransferTypeCard(
                  type: type,
                  label: _resolveLabel(l10n, type.labelKey),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _resolveLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'transferThirdParty':
        return l10n.transferThirdParty;
      case 'transferOwn':
        return l10n.transferOwn;
      case 'transferACH':
        return l10n.transferACH;
      case 'transferInternational':
        return l10n.transferInternational;
      default:
        return key;
    }
  }
}

class _TransferTypeCard extends StatelessWidget {
  const _TransferTypeCard({required this.type, required this.label});

  final TransferTypeEntity type;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconData(type.iconCode, fontFamily: 'MaterialIcons'),
                size: 36,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
