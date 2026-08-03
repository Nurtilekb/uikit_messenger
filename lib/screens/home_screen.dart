import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/home_widgets/home_appbar.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/repositories/chat_repository.dart';
import 'package:uikit/widgets/user_tile.dart';
import 'package:uikit/models/chat_model.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> selectedChatIds = {};
  bool get _isSelectionMode => selectedChatIds.isNotEmpty;

  void _toggleSelection(String id) {
    setState(() {
      if (selectedChatIds.contains(id)) {
        selectedChatIds.remove(id);
      } else {
        selectedChatIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedChatIds.clear();
    });
  }

  final ChatRepository _chatRepository = ChatRepository();

  void _deleteSelectedChats(List<String> idsToDelete) async {
    if (idsToDelete.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чаты?'),
        content: Text(
          'Вы уверены, что хотите удалить ${idsToDelete.length} чат(ов)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _chatRepository.deleteChats(idsToDelete);
              if (!mounted) return;
              _clearSelection();
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Передаем колбэки для управления выделением и удалением
            _isSelectionMode
                ? HomeAppBar2(
                    selectedChatIds: selectedChatIds,
                    clearSelection: _clearSelection,
                    deleteSelectedChats: () =>
                        _deleteSelectedChats(selectedChatIds.toList()),
                    onArchive: () {
                      // TODO: Реализовать архивацию
                    },
                  )
                : HomeAppBar(
                    onTapSearch: () {
                      context.router.push(SearchRoute());
                    },
                    onTapProfile: () {
                      context.router.push(ProfileRoute());
                    },
                  ),
            const SizedBox(height: 10),
            // Передаем функции управления состоянием внутрь виджета со списком
            Expanded(
              child: ChatsList(
                chatRepository: _chatRepository,
                selectedChatIds: selectedChatIds,
                isSelectionMode: _isSelectionMode,
                onToggleSelection: _toggleSelection,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: themeStyle.primaryColor,
        onPressed: () {
          context.router.push(const UsersListRoute());
        },
        child: Icon(Icons.add, color: colors.textOnPrimary),
      ),
    );
  }
}

class ChatsList extends StatelessWidget {
  final ChatRepository chatRepository;
  final bool isSelectionMode;
  final Set<String> selectedChatIds;
  final Function(String) onToggleSelection;

  const ChatsList({
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
        if (chats.isEmpty) {
          return const Center(child: EmptyChatWidget());
        }

        return ListView.separated(
          itemCount: chats.length,
          separatorBuilder: (_, _) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final chat = chats[index];
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
