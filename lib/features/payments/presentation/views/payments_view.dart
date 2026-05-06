import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/payment_type_entity.dart';
import '../providers/payments_notifier_provider.dart';

class PaymentsView extends ConsumerStatefulWidget {
  const PaymentsView({super.key});

  @override
  ConsumerState<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends ConsumerState<PaymentsView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(paymentsNotifierProvider.notifier).loadPaymentTypes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(paymentsNotifierProvider);

    if (state.isLoading && state.paymentTypes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      key: const ValueKey('payments'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.payments,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: state.paymentTypes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final type = state.paymentTypes[index];
                return _PaymentTypeCard(
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
      case 'paymentServicePayment':
        return l10n.paymentServicePayment;
      case 'paymentMobileRecharge':
        return l10n.paymentMobileRecharge;
      default:
        return key;
    }
  }
}

class _PaymentTypeCard extends StatelessWidget {
  const _PaymentTypeCard({required this.type, required this.label});

  final PaymentTypeEntity type;
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
