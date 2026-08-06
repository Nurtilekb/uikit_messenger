import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/blocs/theme/theme_cubit.dart';
import 'package:uikit/models/user_model.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/profile_widgets/profile_avatar.dart';
import 'package:uikit/widgets/profile_widgets/profile_info.dart';
import 'package:uikit/widgets/profile_widgets/profile_settings.dart';
import 'package:uikit/widgets/profile_widgets/profile_logout_button.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _hasProfileChanges = false;
  String _draftName = '';
  bool _isSaving = false;
  UserModel? _lastUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _lastUser = authState.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final shouldShowSuccess = _isSaving;
          if (mounted) {
            setState(() {
              _lastUser = state.user;
              _isSaving = false;
              _hasProfileChanges = false;
              _draftName = '';
            });
          }
          if (mounted && shouldShowSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Изменения сохранены'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (state is AuthError) {
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }
        }
      },
      child: Stack(
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
                    onPressed: _isSaving ? null : _saveProfile,
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
            body: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final user = state is AuthAuthenticated
                    ? state.user
                    : _lastUser;
                final userName = user?.name ?? '';
                final userEmail = user?.email ?? '';
                final displayName =
                    _draftName.isNotEmpty && (_hasProfileChanges || _isSaving)
                    ? _draftName
                    : userName;

                return ColoredBox(
                  color: colors.chatBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 90, color: colors.profileHeader),

                      ProfileInfo(
                        name: displayName,
                        email: userEmail,
                        onChanged: (value) {
                          _handleNameChanged(value);
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
                        builder: (context, themeState) {
                          return ProfileSettings(
                            isDarkMode: themeState.isDarkMode,
                            onDarkModeChanged: (value) {
                              context.read<ThemeCubit>().setTheme(value);
                              _saveThemeMode(value);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      const ProfileLogoutButton(),
                    ],
                  ),
                );
              },
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final user = state is AuthAuthenticated ? state.user : _lastUser;
              return ProfileAvatar(
                initials: user != null && user.name.isNotEmpty
                    ? user.name.split(' ').map((s) => s[0]).join()
                    : '',
              );
            },
          ),
          if (_isSaving)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleNameChanged(String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authState = context.read<AuthBloc>().state;

        if (authState is! AuthAuthenticated) {
          setState(() {
            _hasProfileChanges = false;
            _draftName = '';
          });
          return;
        }

        final trimmedValue = value.trim();
        final originalName = authState.user.name.trim();
        setState(() {
          _draftName = value;
          _hasProfileChanges =
              trimmedValue.isNotEmpty && trimmedValue != originalName;
        });
      }
    });
  }

  Future<void> _saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _saveProfile() async {
    if (_isSaving) {
      return;
    }

    final nameToSave = _draftName.trim();

    if (nameToSave.isEmpty) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    context.read<AuthBloc>().add(UpdateProfileRequested(name: nameToSave));
  }
}
