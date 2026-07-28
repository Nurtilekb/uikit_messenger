import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/blocs/theme/theme_cubit.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/profile_widgets/profile_avatar.dart';
import 'package:uikit/widgets/profile_widgets/profile_info.dart';
import 'package:uikit/widgets/profile_widgets/profile_settings.dart';
import 'package:uikit/widgets/profile_widgets/profile_logout_button.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  final String name;

  const ProfileScreen({super.key, required this.name});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = false;
  bool _hasProfileChanges = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'profile'.tr(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            backgroundColor: colors.cardBackground,
            actions: [
              if (_hasProfileChanges)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hasProfileChanges = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Изменения сохранены')),
                    );
                  },
                  child: Text(
                    'save'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
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
                Container(height: 90, color: colors.profileHeader),

                ProfileInfo(
                  name: 'Мария Ковалева',
                  email: 'maria@email.com',
                  onChanged: (hasChanges) {
                    setState(() {
                      _hasProfileChanges = hasChanges;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                  child: Text(
                    'settings2'.tr(),
                    style: TextStyle(
                      color: colors.iconSecondary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return ProfileSettings(
                      isDarkMode: state.isDarkMode,
                      onDarkModeChanged: (value) {
                        context.read<ThemeCubit>().setTheme(value);
                        _saveThemeMode(value);
                      },
                    );
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

  Future<void> _saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
