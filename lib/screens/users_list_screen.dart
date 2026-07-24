import 'package:flutter/material.dart';
import 'package:uikit/screens/chats_screen.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/user_tile.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colors.cardBackground,
        title: Text(
          'Пользователи',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(24),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return UserTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatsScreen(
                      numName: 'Nurik',
                      isOnline: true,
                      imageAvatar: '',
                    ),
                  ),
                );
              },
              name: "Nurik",
              lastMessage: 'был в сети год назад',
              time: 'вчера',
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 25);
          },
          itemCount: 7,
        ),
      ),
    );
  }
}
