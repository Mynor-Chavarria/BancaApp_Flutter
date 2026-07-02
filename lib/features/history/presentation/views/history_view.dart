import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(key: const ValueKey('history'), child: Text(l10n.history));
  }
}
