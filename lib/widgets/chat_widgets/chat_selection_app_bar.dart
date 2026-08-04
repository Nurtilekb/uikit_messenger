import 'package:flutter/material.dart';

class ChatSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  const ChatSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.onClose,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      title: Text('$selectedCount'),
      actions: [
        IconButton(icon: const Icon(Icons.reply), onPressed: () {}),
        IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
