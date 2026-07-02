import 'package:banca_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../../features/payments/presentation/views/payments_view.dart';
import '../../../features/settings/presentation/views/settings_view.dart';
import '../../../features/transfers/presentation/views/transfers_view.dart';
import '../controllers/global_loader_controller.dart';
import '../providers/home_tabs_provider.dart';
import '../widgets/app_confirm_modal.dart';

class HomeTabsView extends ConsumerWidget {
  const HomeTabsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _HomeTabsContent();
  }
}

class _HomeTabsContent extends ConsumerWidget {
  const _HomeTabsContent();

  static const List<Widget> _tabs = [
    DashboardView(),
    TransfersView(),
    PaymentsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = ref.watch(homeTabsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              final shouldLogout = await AppConfirmModal.show(
                context,
                title: l10n.logout,
                description: l10n.logoutConfirmDescription,
                icon: Icons.logout,
                acceptText: l10n.accept,
                cancelText: l10n.cancel,
              );

              if (shouldLogout != true || !context.mounted) {
                return;
              }

              GlobalLoaderController.instance.setLoading(
                true,
                message: l10n.loggingOut,
              );

              await ref.read(authNotifierProvider.notifier).logout();

              GlobalLoaderController.instance.setLoading(false);

              if (!context.mounted) {
                return;
              }

              context.goNamed(AppRoutes.loginName);
            },
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(homeTabsProvider.notifier).setCurrentIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_outlined),
            selectedIcon: const Icon(Icons.swap_horiz),
            label: l10n.transfers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.payment_outlined),
            selectedIcon: const Icon(Icons.payment),
            label: l10n.payments,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
