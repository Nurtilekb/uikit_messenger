import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/home_widgets/user_avatar.dart';
import 'package:uikit/widgets/home_widgets/user_tile_content.dart';

class UserTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback _onlongPress;

  const UserTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.avatarUrl = '',
    this.unreadCount = 0,
    this.isOnline = false,
    this.isSelected = false,
    this.onTap,
    required this._onlongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: isSelected
          ? colors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        onLongPress: _onlongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              UserAvatar(name: name, avatarUrl: avatarUrl, isOnline: isOnline),
              const SizedBox(width: 14),
              Expanded(
                child: UserTileContent(
                  name: name,
                  lastMessage: lastMessage,
                  time: time,
                  unreadCount: unreadCount,
                  isOnline: isOnline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
