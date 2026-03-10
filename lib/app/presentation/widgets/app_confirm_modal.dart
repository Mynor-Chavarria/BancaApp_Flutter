import 'package:flutter/material.dart';

class AppConfirmModal extends StatelessWidget {
  const AppConfirmModal({
    required this.title,
    required this.description,
    required this.icon,
    required this.onAccept,
    required this.onCancel,
    this.acceptText = 'Aceptar',
    this.cancelText = 'Cancelar',
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final String acceptText;
  final String cancelText;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    String acceptText = 'Aceptar',
    String cancelText = 'Cancelar',
    bool barrierDismissible = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AppConfirmModal(
          title: title,
          description: description,
          icon: icon,
          acceptText: acceptText,
          cancelText: cancelText,
          onAccept: () => Navigator.of(dialogContext).pop(true),
          onCancel: () => Navigator.of(dialogContext).pop(false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: colorScheme.onPrimaryContainer, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                child: Text(cancelText),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(onPressed: onAccept, child: Text(acceptText)),
            ),
          ],
        ),
      ],
    );
  }
}
