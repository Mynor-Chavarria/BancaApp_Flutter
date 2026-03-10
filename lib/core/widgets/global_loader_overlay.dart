import 'package:flutter/material.dart';

import '../../app/presentation/controllers/global_loader_controller.dart';
import '../theme/app_colors.dart';

class GlobalLoaderOverlay extends StatelessWidget {
  const GlobalLoaderOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<GlobalLoaderState>(
      valueListenable: GlobalLoaderController.instance.state,
      builder: (context, loaderState, _) {
        return Stack(
          children: [
            child,
            if (loaderState.isVisible)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          if ((loaderState.message ?? '').isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              loaderState.message!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
