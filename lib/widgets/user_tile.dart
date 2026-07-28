import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class UserTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback? onTap;

  const UserTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.avatarUrl = '',
    this.unreadCount = 1,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String getInitials(String fullName) {
      if (fullName.isEmpty) return '';

      final parts = fullName.trim().split(' ');
      if (parts.length == 1) {
        return parts[0][0].toUpperCase();
      }

      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
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
                        ? Center(
                            child: Text(
                              getInitials(name),
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight(500),
                                color: colors.textHint,
                              ),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            maxLines: 1,
                            style: textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount.toString(),
                                style: TextStyle(
                                  color: colors.textOnPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
