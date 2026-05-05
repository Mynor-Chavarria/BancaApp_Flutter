import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      key: const ValueKey('dashboard'),
      child: Text(l10n.dashboard),
    );
  }
}
