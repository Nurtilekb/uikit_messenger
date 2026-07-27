import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final VoidCallback onlongTap;
  final VoidCallback ontapp;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.onlongTap,
    required this.ontapp,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onLongPress: onlongTap,
                onTap: ontapp,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? colors.primary : colors.messageBubbleOther,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isMe
                              ? colors.textOnPrimary
                              : colors.messageTextOther,
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe
                              ? colors.textOnPrimary.withValues(alpha: 0.7)
                              : colors.messageTimeOther,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
