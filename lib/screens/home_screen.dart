import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:uikit/models/chat_model.dart';
import 'package:uikit/router/app_router.dart';

import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/appbar_button.dart';
import 'package:uikit/widgets/empty_contacts_state.dart';
import 'package:uikit/widgets/user_tile.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEmpty = false;

  List<Chat> chats = [
    Chat(
      name: 'Kutman Sayitkanov',
      lastMessage: 'bro, go to gym today?',
      time: '22 июня',
      avatar: '',
      unreadCount: 3,
      isOnline: true,
    ),
    Chat(
      name: 'Aigerim',
      lastMessage: 'Спасибо за помощь! 😊',
      time: 'Сегодня',
      avatar: '',
      unreadCount: 0,
      isOnline: false,
    ),
    Chat(
      name: 'Bekzat',
      lastMessage: 'Когда встречаемся?',
      time: 'Вчера',
      avatar: '',
      unreadCount: 5,
      isOnline: true,
    ),
    Chat(
      name: 'Daniyar Ermatov',
      lastMessage: 'Мы можем с вами встретиться?',
      time: '12:30',
      avatar: '',
      unreadCount: 1,
      isOnline: false,
    ),
    Chat(
      name: 'Aizhan Matraimova',
      lastMessage: 'Давай сегодя пойдем в ынтымак за ручки держась',
      time: '11:45',
      avatar: '',
      unreadCount: 0,
      isOnline: true,
    ),
    Chat(
      name: 'Ruslan',
      lastMessage: 'Где ты? Я уже на месте',
      time: '10:00',
      avatar: '',
      unreadCount: 2,
      isOnline: false,
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
                      onTap: () {
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
          context.router.push(const UsersListRoute());
        },
        child: Icon(Icons.add, color: colors.textOnPrimary),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final void Function()? onTapSearch;
  final VoidCallback? onTapProfile;
  const HomeAppBar({this.onTapSearch, this.onTapProfile, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);

    return AppBar(
      backgroundColor: colors.cardBackground,
      actionsPadding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
      title: Text(
        "chats".tr(),
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: colors.textPrimary,
        ),
      ),
      actions: [
        CircleIconButton(
          childd: Icon(Icons.search, size: 27, color: colors.textPrimary),
          onTap: onTapSearch,
        ),
        const SizedBox(width: 12),
        CircleIconButton(
          childd: Text(
            "me".tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          background: themeStyle.dividerColor,
          onTap: onTapProfile,
        ),
      ],
    );
  }
}
