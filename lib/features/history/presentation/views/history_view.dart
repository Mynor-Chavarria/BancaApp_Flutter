import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryProvider>(
      create: (_) => HistoryProvider(),
      child: const _HistoryContent(),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<HistoryProvider>(context);

    return Center(key: ValueKey(provider.screenId), child: Text(l10n.history));
  }
}
