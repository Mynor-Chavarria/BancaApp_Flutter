import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsProvider>(
      create: (_) => SettingsProvider(),
      child: const _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<SettingsProvider>(context);
    final currentLanguageCode =
        provider.currentLanguageCode ??
        Localizations.localeOf(context).languageCode;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 8),
                    Text(
                      l10n.settings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: currentLanguageCode,
                  decoration: InputDecoration(
                    labelText: l10n.language,
                    filled: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                    DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    Provider.of<SettingsProvider>(
                      context,
                      listen: false,
                    ).setLanguageCode(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
