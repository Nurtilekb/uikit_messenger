import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/profile_widgets/profile_avatar.dart';
import 'package:uikit/widgets/profile_widgets/profile_info.dart';
import 'package:uikit/widgets/profile_widgets/profile_settings.dart';
import 'package:uikit/widgets/profile_widgets/profile_logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Профиль',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: colors.textPrimary),
            ),
            backgroundColor: colors.cardBackground,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ColoredBox(
            color: colors.chatBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90,
                  color: colors.profileHeader,
                ),
                ProfileInfo(name: 'Мария Ковалева', email: 'maria@email.com'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                  child: Text(
                    'НАСТРОЙКИ',
                    style: TextStyle(
                      color: colors.iconSecondary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ProfileSettings(
                  isDarkMode: isSwitched,
                  onDarkModeChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ProfileLogoutButton(),
              ],
            ),
          ),
        ),
        ProfileAvatar(initials: 'MK'),
      ],
    );
  }
}
