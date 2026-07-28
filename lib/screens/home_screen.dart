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
  bool get _isSelectionMode => selectedUserIds.isNotEmpty;
  final Set<String> selectedUserIds = {};
  void _toggleSelection(String id) {
    setState(() {
      if (selectedUserIds.contains(id)) {
        selectedUserIds.remove(id);
      } else {
        selectedUserIds.add(id);
      }
    });
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
            HomeAppBar(
              onTapProfile: () =>
                  context.pushRoute(ProfileRoute(name: 'nurtilek')),
              onTapSearch: () => context.pushRoute(const SearchRoute()),
            ),
            const SizedBox(height: 30),
            if (chats.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 25),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return UserTile(
                      onlongpress: () {
                        _toggleSelection(chat.id);
                      },
                      onTap: () {
                        if (_isSelectionMode) {
                          _toggleSelection(chat.id);
                        }
                        context.router.push(
                          ChatsRoute(
                            numName: chat.name,
                            isOnline: chat.isOnline,
                            imageAvatar: chat.avatar,
                          ),
                        );
                      },
                      name: chat.name,
                      lastMessage: chat.lastMessage,
                      isOnline: chat.isOnline,
                      unreadCount: chat.unreadCount,
                      avatarUrl: chat.avatar,
                      time: chat.time,
                    );
                  },
                ),
              ),
            if (chats.isEmpty) Center(child: EmptyChatWidget()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: themeStyle.primaryColor,
        onPressed: () {
          context.router.push(UsersListRoute());
        },
        child: Icon(Icons.add, color: colors.textOnPrimary),
      ),
    );
  }
}
