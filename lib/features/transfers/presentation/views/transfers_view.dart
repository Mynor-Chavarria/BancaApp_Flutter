import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/transfers_provider.dart';

class TransfersView extends StatelessWidget {
  const TransfersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransfersProvider>(
      create: (_) => TransfersProvider(),
      child: const _TransfersContent(),
    );
  }
}

class _TransfersContent extends StatelessWidget {
  const _TransfersContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<TransfersProvider>(context);

    return Center(
      key: ValueKey(provider.screenId),
      child: Text(l10n.transfers),
    );
  }
}
