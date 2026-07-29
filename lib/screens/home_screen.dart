import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:uikit/models/chat_model.dart';
import 'package:uikit/router/app_router.dart';

import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/widgets/home_widgets/home_appbar.dart';
import 'package:uikit/widgets/user_tile.dart';

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

  void _onArchive() {
    setState(() {
      final archived = chats
          .where((chat) => selectedChatIds.contains(chat.id))
          .toList();

      chats.removeWhere((chat) => selectedChatIds.contains(chat.id));
      selectedChatIds.clear();
    });
  }

  void _deleteSelectedChats() {
    if (selectedChatIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить чаты?'),
        content: Text(
          'Вы уверены, что хотите удалить ${selectedChatIds.length} чат(ов)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                chats.removeWhere((chat) => selectedChatIds.contains(chat.id));
                selectedChatIds.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool isEmpty = false;

  List<Chat> chats = [
    Chat(
      name: 'Kutman Sayitkanov',
      lastMessage: 'bro, go to gym today?',
      time: '22 июня',
      avatar: '',
      unreadCount: 3,
      isOnline: true,
      id: '1',
    ),
    Chat(
      name: 'Aigerim',
      lastMessage: 'Спасибо за помощь! 😊',
      time: 'Сегодня',
      avatar: '',
      unreadCount: 0,
      isOnline: false,
      id: '2',
    ),
    Chat(
      name: 'Bekzat',
      lastMessage: 'Когда встречаемся?',
      time: 'Вчера',
      avatar: '',
      unreadCount: 5,
      isOnline: true,
      id: '3',
    ),
    Chat(
      name: 'Daniyar Ermatov',
      lastMessage: 'Мы можем с вами встретиться?',
      time: '12:30',
      avatar: '',
      unreadCount: 1,
      isOnline: false,
      id: '4',
    ),
    Chat(
      name: 'Aizhan Matraimova',
      lastMessage: 'Давай сегодя пойдем в ынтымак за ручки держась',
      time: '11:45',
      avatar: '',
      unreadCount: 0,
      isOnline: true,
      id: '5',
    ),
    Chat(
      name: 'Ruslan',
      lastMessage: 'Где ты? Я уже на месте',
      time: '10:00',
      avatar: '',
      unreadCount: 2,
      isOnline: false,
      id: '6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _isSelectionMode
                ? HomeAppBar2(
                    wefwef: selectedChatIds,
                    clearSelection: _clearSelection,
                    deleteSelectedChats: _deleteSelectedChats,
                    onArchive: _onArchive,
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
            if (chats.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final isSelected = selectedChatIds.contains(chat.id);

                    return UserTile(
                      onTap: () {
                        if (_isSelectionMode) {
                          _toggleSelection(chat.id);
                        } else {
                          context.router.push(
                            ChatsRoute(
                              numName: chat.name,
                              isOnline: chat.isOnline,
                              imageAvatar: chat.avatar,
                            ),
                          );
                        }
                      },
                      onlongPress: () {
                        _toggleSelection(chat.id);
                      },
                      name: chat.name,
                      lastMessage: chat.lastMessage,
                      isOnline: chat.isOnline,
                      unreadCount: chat.unreadCount,
                      avatarUrl: chat.avatar,
                      time: chat.time,
                      isSelected: isSelected,
                    );
                  },
                ),
              ),
            if (chats.isEmpty) const Center(child: EmptyChatWidget()),
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
