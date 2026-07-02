import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/history_entity.dart';
import '../providers/account_history_notifier_provider.dart';

class AccountHistoryView extends ConsumerStatefulWidget {
  const AccountHistoryView({
    required this.accountId,
    required this.accountName,
    super.key,
  });

  final String accountId;
  final String accountName;

  @override
  ConsumerState<AccountHistoryView> createState() => _AccountHistoryViewState();
}

class _AccountHistoryViewState extends ConsumerState<AccountHistoryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(accountHistoryNotifierProvider.notifier)
          .loadTransactions(widget.accountId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(accountHistoryNotifierProvider);
    final notifier = ref.read(accountHistoryNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.accountHistory} - ${widget.accountName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            _FiltersRow(
              fromDate: state.fromDate,
              toDate: state.toDate,
              selectedType: state.selectedType,
              onFromTap: () async {
                final selected = await _pickDate(
                  context,
                  initial: state.fromDate ?? DateTime.now(),
                );
                if (selected != null) notifier.setFromDate(selected);
              },
              onToTap: () async {
                final selected = await _pickDate(
                  context,
                  initial: state.toDate ?? DateTime.now(),
                );
                if (selected != null) notifier.setToDate(selected);
              },
              onTypeChanged: notifier.setTransactionType,
              onClear: notifier.clearFilters,
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (state.filtered.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    l10n.noTransactions,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: state.filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final tx = state.filtered[index];
                    return _TransactionTile(transaction: tx);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(
    BuildContext context, {
    required DateTime initial,
  }) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.fromDate,
    required this.toDate,
    required this.selectedType,
    required this.onFromTap,
    required this.onToTap,
    required this.onTypeChanged,
    required this.onClear,
  });

  final DateTime? fromDate;
  final DateTime? toDate;
  final TransactionType? selectedType;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final ValueChanged<TransactionType?> onTypeChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onFromTap,
                icon: const Icon(Icons.calendar_today_outlined, size: 16),
                label: Text(
                  '${l10n.filterFrom}: ${fromDate != null ? dateFormat.format(fromDate!) : l10n.selectDate}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onToTap,
                icon: const Icon(Icons.event_outlined, size: 16),
                label: Text(
                  '${l10n.filterTo}: ${toDate != null ? dateFormat.format(toDate!) : l10n.selectDate}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<TransactionType?>(
                initialValue: selectedType,
                decoration: InputDecoration(
                  labelText: l10n.movementType,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem<TransactionType?>(
                    value: null,
                    child: Text(l10n.allMovements),
                  ),
                  DropdownMenuItem<TransactionType?>(
                    value: TransactionType.credit,
                    child: Text(l10n.credit),
                  ),
                  DropdownMenuItem<TransactionType?>(
                    value: TransactionType.debit,
                    child: Text(l10n.debit),
                  ),
                ],
                onChanged: onTypeChanged,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(onPressed: onClear, child: Text(l10n.clearFilters)),
          ],
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final AccountTransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final amountPrefix = isCredit ? '+' : '-';
    final amountColor = isCredit ? Colors.green : Colors.red;
    final date = DateFormat('dd/MM/yyyy').format(transaction.date);
    final amount = NumberFormat(
      'Q #,##0.00',
      'en_US',
    ).format(transaction.amount);

    return Card(
      child: ListTile(
        title: Text(transaction.description),
        subtitle: Text(date),
        trailing: Text(
          '$amountPrefix$amount',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
