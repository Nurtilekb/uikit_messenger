import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/Chat_widgets/Chat_message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final AppColors colors;
  final String? currentUserId;
  final Set<String> selectedMessageIds;
  final bool isSelectionMode;
  final ScrollController scrollController;
  final void Function(String id) onToggleSelection;

  const ChatMessageList({
    super.key,
    required this.docs,
    required this.colors,
    required this.currentUserId,
    required this.selectedMessageIds,
    required this.isSelectionMode,
    required this.scrollController,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return Center(
        child: Text(
          'Сообщений пока нет',
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: docs.length,
      itemBuilder: (_, index) {
        final doc = docs[index];
        final message = doc.data();
        final isMe = message['senderId'] == currentUserId;
        final isSelected = selectedMessageIds.contains(doc.id);
        final timeText =
            message['sendAt'] ??
            (message['createdAt'] is Timestamp
                ? (message['createdAt'] as Timestamp)
                      .toDate()
                      .toLocal()
                      .toString()
                : '');

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          child: ChatMessageBubble(
            text: message['text'] ?? '',
            isMe: isMe,
            time: timeText,
            onlongTap: () => onToggleSelection(doc.id),
            ontapp: () {
              if (isSelectionMode) {
                onToggleSelection(doc.id);
              }
            },
          ),
        );
      },
    );
  }
}
