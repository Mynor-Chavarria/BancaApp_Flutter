import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../../features/history/presentation/views/history_view.dart';
import '../../../features/login/presentation/views/login_view.dart';
import '../../../features/settings/presentation/views/settings_view.dart';
import '../../../features/transfers/presentation/views/transfers_view.dart';
import '../controllers/global_loader_controller.dart';
import '../providers/home_tabs_provider.dart';
import '../widgets/app_confirm_modal.dart';

class HomeTabsView extends StatelessWidget {
  const HomeTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabsProvider>(
      create: (_) => HomeTabsProvider(),
      child: const _HomeTabsContent(),
    );
  }
}

class _HomeTabsContent extends StatelessWidget {
  const _HomeTabsContent();

  static const List<Widget> _tabs = [
    DashboardView(),
    TransfersView(),
    HistoryView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<HomeTabsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
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

              await Future<void>.delayed(const Duration(seconds: 2));

              GlobalLoaderController.instance.setLoading(false);

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: provider.currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: provider.currentIndex,
        onDestinationSelected: (index) {
          Provider.of<HomeTabsProvider>(
            context,
            listen: false,
          ).setCurrentIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_outlined),
            selectedIcon: const Icon(Icons.swap_horiz),
            label: l10n.transfers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.history,
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
