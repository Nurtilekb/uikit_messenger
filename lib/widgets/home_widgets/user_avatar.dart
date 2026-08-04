import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;

  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl = '',
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    String getInitials(String fullName) {
      if (fullName.isEmpty) return '';

      final parts = fullName.trim().split(' ');
      if (parts.length == 1) {
        return parts[0][0].toUpperCase();
      }

      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return Stack(
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
                      fontWeight: FontWeight.w500,
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
                border: Border.all(color: colors.cardBackground, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
