import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final bool isOnline;
  final String avatarUrl;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.isOnline,
    required this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppBar(
      backgroundColor: colors.cardBackground,
      elevation: 0,
      titleSpacing: 0,
      actionsPadding: const EdgeInsets.only(right: 8),
      actions: [
        PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(
            Icons.more_vert_outlined,
            size: 29,
            color: colors.iconPrimary,
          ),
          onSelected: (_) {},
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_sweep_outlined, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'delete'.tr(),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      title: Row(
        children: [
          _buildAvatar(context, colors),
          const SizedBox(width: 12),
          _buildUserInfo(context, colors),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, AppColors colors) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).dividerColor,
          ),
          child: avatarUrl.isEmpty
              ? Center(
                  child: Text(
                    getInitials(userName),
                    style: const TextStyle(fontSize: 14),
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colors.online,
                shape: BoxShape.circle,
                border: Border.all(color: colors.cardBackground, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ),
        Text(
          isOnline ? 'online'.tr() : 'offline'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: isOnline ? colors.online : colors.textSecondary,
          ),
        ),
      ],
    );
  }

  String getInitials(String fullName) {
    if (fullName.isEmpty) return '';

    final parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
