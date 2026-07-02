import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_notifier_provider.dart';
import '../state/profile_state.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _ProfileBody(state: state, l10n: l10n, theme: theme),
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({
    required this.state,
    required this.l10n,
    required this.theme,
  });

  final ProfileState state;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.profile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? l10n.profileLoadFailed,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                ref.read(profileNotifierProvider.notifier).loadProfile();
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final profile = state.profile;
    if (profile == null) {
      return Center(child: Text(l10n.noProfileData));
    }

    final fullName = [profile.firstName, profile.lastName]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' ');

    return ListView(
      children: [
        Card.filled(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage:
                      profile.image != null && profile.image!.trim().isNotEmpty
                          ? NetworkImage(profile.image!)
                          : null,
                  child:
                      profile.image == null || profile.image!.trim().isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  fullName.isEmpty ? profile.username : fullName,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card.outlined(
          child: Column(
            children: [
              _ProfileInfoTile(
                label: l10n.userId,
                value: profile.id.toString(),
              ),
              _ProfileInfoTile(label: l10n.username, value: profile.username),
              _ProfileInfoTile(
                label: l10n.fullName,
                value: fullName.isEmpty ? '-' : fullName,
              ),
              _ProfileInfoTile(label: l10n.emailAddress, value: profile.email),
              _ProfileInfoTile(
                label: l10n.gender,
                value:
                    (profile.gender?.trim().isNotEmpty ?? false)
                        ? profile.gender!
                        : '-',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(label), subtitle: Text(value));
  }
}
