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
      name: 'Nurtilek',
      lastMessage: 'bro go to afsasdb asfdg wert werthy retqwer gtrewgwt r wet',
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
      name: 'Daniyar',
      lastMessage: 'Ок, договорились 👍',
      time: '12:30',
      avatar: '',
      unreadCount: 1,
      isOnline: false,
    ),
    Chat(
      name: 'Aizhan',
      lastMessage: 'С днем рождения! 🎉',
      time: '11:45',
      avatar: '',
      unreadCount: 0,
      isOnline: true,
    ),
    Chat(
      name: 'Ruslan',
      lastMessage: 'Где ты? Я уже на месте',
      time: '10:00',
      avatar:
          'https://media.gq-magazine.co.uk/photos/5d1392adb363fa622820c7ec/1:1/w_1280,h_1280,c_limit/Conor-McGregor-GQ-20Dec16_rex_b.jpg',
      unreadCount: 2,
      isOnline: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final themeStyle = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
                  child: Row(
                    children: [
                      Text(
                        "chats".tr(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: colors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      CircleIconButton(
                        childd: Icon(
                          Icons.search,
                          size: 27,
                          color: colors.textPrimary,
                        ),
                        onTap: () {
                          context.router.push(const SearchRoute());
                        },
                      ),
                      const SizedBox(width: 12),
                      CircleIconButton(
                        childd: Text(
                          "me".tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        background: themeStyle.dividerColor,
                        onTap: () {
                          context.router.push(ProfileRoute(name: 'nurtilek'));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (chats.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 2, 24, 100),
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
        ],
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
