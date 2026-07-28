import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/app_text_field.dart';

class ChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ColoredBox(
      color: colors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: AppInputWidget(
                maxLines: 3,
                controller: controller,
                radius: 25,
                borderColor: colors.cardBackground,
                hintText: 'Сообщение',
                filledColor: colors.composerInputBackground,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onSend,
                icon: Icon(Icons.send, color: colors.textOnPrimary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
