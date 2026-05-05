import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TransfersView extends StatelessWidget {
  const TransfersView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      key: const ValueKey('transfers'),
      child: Text(l10n.transfers),
    );
  }
}
