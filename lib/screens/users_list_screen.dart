import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/models/user_model.dart';
import 'package:uikit/repositories/user_repository.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/home_widgets/user_avatar.dart';

@RoutePage()
class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UserRepository _userRepository = UserRepository();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userRepository.getUsers();
    if (!mounted) return;
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: _handleAuthState,
            builder: (context, state) {
              if (_isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_users.isEmpty) {
                return Center(
                  child: Text(
                    'Пользователи не найдены',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                );
              }
              return ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (_, _) => const SizedBox(height: 25),
                itemBuilder: (_, index) =>
                    _buildUserItem(context, _users[index], colors),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
    if (state is AuthUnauthenticated) {
      context.router.replaceAll([const AuthRoute()]);
    }
  }

  Widget _buildUserItem(
    BuildContext context,
    UserModel user,
    AppColors colors,
  ) {
    return InkWell(
      onTap: () => context.router.push(
        ChatsRoute(
          numName: user.name,
          isOnline: user.isOnline,
          imageAvatar: '',
          userId: user.id,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 7, 24, 7),
        child: Row(
          children: [
            Stack(
              children: [
                UserAvatar(
                  name: user.name,
                  avatarUrl: '',
                  isOnline: user.isOnline,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.isOnline
                          ? colors.online
                          : colors.textSecondary,
                      border: Border.all(
                        color: colors.cardBackground,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name.isNotEmpty ? user.name : 'No Name',
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    user.email.isNotEmpty ? user.email : 'No Email',
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
