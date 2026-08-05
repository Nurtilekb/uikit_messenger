import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String cancelText = 'Cancel',
  String confirmText = 'Delete',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText, style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

Future<void> showLoadingDialog(
  BuildContext context, {
  bool barrierDismissible = false,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: true,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
}
