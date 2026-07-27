import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/screens/chats_screen.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/user_tile.dart';

@RoutePage()
class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        backgroundColor: colors.cardBackground,
        title: Text(
          'users'.tr(),
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SafeArea(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: UserTile(
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
                  lastMessage: 'Today or tomorrow ',
                  time: 'yesterday'.tr(),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 25);
            },
            itemCount: 13,
          ),
        ),
      ),
    );
  }
}
