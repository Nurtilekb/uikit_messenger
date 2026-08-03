import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/home_widgets/home_appbar.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/repositories/chat_repository.dart';
import 'package:uikit/widgets/user_tile.dart';
import 'package:uikit/models/chat_model.dart';
import 'package:uikit/repositories/user_repository.dart';

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

  void _deleteSelectedChats(List<String> idsToDelete) {
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
              // Вызываем удаление в репозитории

              // Очищаем выделение после удаления
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
  final bool isSelectionMode;
  final Function(String) onToggleSelection;

  final UserRepository _userRepository = UserRepository();

  ChatsList({
    super.key,
    required this.isSelectionMode,
    required this.onToggleSelection,
  });

  String? _currentUserId() => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final currentUserId = _currentUserId();

    if (currentUserId == null) {
      return const Center(child: Text('Пользователь не авторизован'));
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participantIds', arrayContains: currentUserId)
          .orderBy('updatedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error loading chats: ${snapshot.error}');
          return Center(
            child: Text('Ошибка загрузки чатов: ${snapshot.error}'),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(child: EmptyChatWidget());
        }

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();
            final chatId = doc.id;

            // Извлекаем данные
            final participantIds = List<String>.from(
              data['participantIds'] ?? [],
            );
            final lastMessage = data['lastMessage'] ?? '';
            final updatedAt = data['updatedAt'] as Timestamp?;

            String otherUserId = participantIds.firstWhere(
              (id) => id != currentUserId,
              orElse: () =>
                  participantIds.isNotEmpty ? participantIds.first : '',
            );

            final rawName = (data['name'] as String?)?.trim();
            final avatarUrl = data['avatarUrl'] ?? '';
            final isOnline =
                false; // Статус онлайн нужно хранить отдельно или вычислять
            final unreadCount = data['unreadCount'] ?? 0;

            // Форматируем время
            String timeString = '';
            if (updatedAt != null) {
              final date = updatedAt.toDate();
              final now = DateTime.now();
              final difference = now.difference(date);

              if (difference.inDays == 0) {
                timeString =
                    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
              } else if (difference.inDays < 7) {
                const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                timeString = days[date.weekday - 1];
              } else {
                timeString = '${date.day}.${date.month}';
              }
            }

            final isSelected =
                isSelectionMode &&
                (context
                        .findAncestorStateOfType<_HomeScreenState>()
                        ?.selectedChatIds
                        .contains(chatId) ??
                    false);

            final Widget tileWidget;
            if (rawName != null && rawName.isNotEmpty) {
              tileWidget = UserTile(
                onTap: () {
                  if (isSelectionMode) {
                    onToggleSelection(chatId);
                  } else {
                    context.router.push(
                      ChatsRoute(
                        numName: rawName,
                        userId: chatId,
                        isOnline: false,
                        imageAvatar: '',
                      ),
                    );
                  }
                },
                name: rawName,
                lastMessage: lastMessage,
                isOnline: isOnline,
                unreadCount: unreadCount,
                avatarUrl: avatarUrl,
                time: timeString,
                isSelected: isSelected,
                onlongPress: () {
                  onToggleSelection(chatId);
                },
              );
            } else {
              tileWidget = FutureBuilder(
                future: _userRepository.getUserById(otherUserId),
                builder: (context, AsyncSnapshot<dynamic> snap) {
                  final resolvedName = snap.hasData && snap.data != null
                      ? (snap.data!.name as String)
                      : (otherUserId.isNotEmpty ? otherUserId : 'Unknown');

                  return UserTile(
                    onTap: () {
                      if (isSelectionMode) {
                        onToggleSelection(chatId);
                      } else {
                        context.router.push(
                          ChatsRoute(
                            numName: resolvedName,
                            userId: chatId,
                            isOnline: false,
                            imageAvatar: avatarUrl,
                          ),
                        );
                      }
                    },
                    name: resolvedName,
                    lastMessage: lastMessage,
                    isOnline: isOnline,
                    unreadCount: unreadCount,
                    avatarUrl: avatarUrl,
                    time: timeString,
                    isSelected: isSelected,
                    onlongPress: () {
                      onToggleSelection(chatId);
                    },
                  );
                },
              );
            }

            return tileWidget;
          },
        );
      },
    );
  }
}
