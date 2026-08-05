import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/models/chat_model.dart';
import 'package:uikit/repositories/chat_repository.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/widgets/user_tile.dart';

class ChatsListView extends StatelessWidget {
  final ChatRepository chatRepository;
  final bool isSelectionMode;
  final Set<String> selectedChatIds;
  final Function(String) onToggleSelection;

  const ChatsListView({
    super.key,
    required this.chatRepository,
    required this.selectedChatIds,
    required this.isSelectionMode,
    required this.onToggleSelection,
  });

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    if (difference.inDays < 7) {
      const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
      return days[time.weekday - 1];
    }
    return '${time.day}.${time.month}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);
    return StreamBuilder<List<Chat>>(
      stream: chatRepository.streamChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка загрузки чатов: ${snapshot.error}'),
          );
        }

        final chats = snapshot.data ?? [];
        // Only show chats that have a last message for the list view.
        final visibleChats = chats
            .where((c) => c.lastMessage.isNotEmpty)
            .toList();

        if (visibleChats.isEmpty) {
          return Center(
            child: EmptyChatWidget(
              title: 'nochatsyet'.tr(),
              subtitle: 'startconv'.tr(),
              icon: Icons.messenger,
              actionButton: InkWell(
                onTap: () {
                  context.router.push(UsersListRoute());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeStyle.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  child: Center(
                    child: Text(
                      '+newchat'.tr(),
                      style: TextStyle(
                        color: colors.textOnPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: visibleChats.length,
          separatorBuilder: (_, _) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final chat = visibleChats[index];
            final isSelected = selectedChatIds.contains(chat.chatID);

            return UserTile(
              onTap: () {
                if (isSelectionMode) {
                  onToggleSelection(chat.chatID);
                } else {
                  context.router.push(
                    ChatsRoute(
                      numName: chat.name,
                      userId: chat.otherUserId,
                      isOnline: false,
                      imageAvatar: chat.avatarUrl,
                    ),
                  );
                }
              },
              name: chat.name,
              lastMessage: chat.lastMessage,
              unreadCount: chat.unreadCount,
              avatarUrl: chat.avatarUrl,
              time: _formatTimestamp(chat.time),
              isSelected: isSelected,
              onlongPress: () {
                onToggleSelection(chat.chatID);
              },
            );
          },
        );
      },
    );
  }
}
