import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/history_entity.dart';
import '../providers/account_history_notifier_provider.dart';
import '../state/account_history_state.dart';

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
  late final ScrollController _scrollController;
  bool _isRequestingNextPage = false;
  DateTime _nextAutoLoadAllowedAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(
      () => ref
          .read(accountHistoryNotifierProvider.notifier)
          .loadFirstPage(widget.accountId),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
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
            else if (state.errorMessage != null && state.filtered.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed:
                              () => notifier.loadFirstPage(widget.accountId),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
              )
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
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.filtered.length + _footerItemCount(state),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    if (index >= state.filtered.length) {
                      return _PaginationFooter(
                        isLoadingMore: state.isLoadingMore,
                        errorMessage: state.errorMessage,
                        onLoadMore: _loadNextPageOnce,
                      );
                    }

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

  int _footerItemCount(AccountHistoryState state) {
    return state.isLoadingMore || state.hasMore || state.errorMessage != null
        ? 1
        : 0;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      _loadNextPageOnce(fromScroll: true);
    }
  }

  Future<void> _loadNextPageOnce({bool fromScroll = false}) async {
    if (fromScroll && DateTime.now().isBefore(_nextAutoLoadAllowedAt)) {
      return;
    }

    final state = ref.read(accountHistoryNotifierProvider);
    if (_isRequestingNextPage ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    _isRequestingNextPage = true;
    _nextAutoLoadAllowedAt = DateTime.now().add(
      const Duration(milliseconds: 900),
    );
    await ref
        .read(accountHistoryNotifierProvider.notifier)
        .loadNextPage(widget.accountId);

    if (!mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isRequestingNextPage = false;
      _nextAutoLoadAllowedAt = DateTime.now().add(
        const Duration(milliseconds: 900),
      );
    });
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

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.isLoadingMore,
    required this.errorMessage,
    required this.onLoadMore,
  });

  final bool isLoadingMore;
  final String? errorMessage;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          if (errorMessage != null) ...[
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
          ],
          OutlinedButton(onPressed: onLoadMore, child: Text(l10n.loadMore)),
        ],
      ),
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
