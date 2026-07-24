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
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: colors.iconPrimary, size: 28),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert_outlined,
            size: 29,
            color: colors.iconPrimary,
          ),
        ),
      ],
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface,
                  image: avatarUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: avatarUrl.isEmpty
                    ? Icon(Icons.person, size: 30, color: colors.iconSecondary)
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
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                isOnline ? 'в сети' : 'был(а) недавно',
                style: TextStyle(
                  fontSize: 14,
                  color: isOnline ? colors.online : colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
