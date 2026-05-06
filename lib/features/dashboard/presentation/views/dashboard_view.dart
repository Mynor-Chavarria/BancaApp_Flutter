import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../providers/dashboard_notifier_provider.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardNotifierProvider.notifier).loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dashboardNotifierProvider);
    final quetzalesFormatter = NumberFormat('Q #,##0.00', 'en_US');

    if (state.isLoading && state.accounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.accounts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  ref.read(dashboardNotifierProvider.notifier).loadAccounts();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (state.accounts.isEmpty) {
      return Center(child: Text(l10n.noAccountsData));
    }

    return ListView(
      key: const ValueKey('dashboard'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          l10n.home,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.myAccounts,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...state.accounts.map((account) {
          final localizedAccountName = _resolveAccountName(
            l10n,
            account.accountName,
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap:
                  () => context.pushNamed(
                    AppRoutes.accountHistoryName,
                    extra: {
                      'accountId': account.accountNumber,
                      'accountName': localizedAccountName,
                    },
                  ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizedAccountName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account.accountNumber,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account.accountHolderName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            quetzalesFormatter.format(
                              account.amountInQuetzales,
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  String _resolveAccountName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'accountMonetary':
        return l10n.accountMonetary;
      case 'accountSaving':
        return l10n.accountSaving;
      default:
        return key;
    }
  }
}
