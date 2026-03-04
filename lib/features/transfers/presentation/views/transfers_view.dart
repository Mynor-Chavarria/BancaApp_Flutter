import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransfersView extends StatelessWidget {
  const TransfersView({super.key});

  @override
  Widget build(BuildContext context) {
     final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(l10n.transfers),
    );
  }
}
