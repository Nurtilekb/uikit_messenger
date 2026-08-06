import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class SearchChatTile extends StatelessWidget {
  final String name;
  final String gmailAccaunt;
  final bool isOnline;
  final VoidCallback? onTap;

  const SearchChatTile({
    super.key,
    required this.name,
    required this.gmailAccaunt,
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
    final getterStyle = Theme.of(context);
    return InkWell(
      onTap: onTap,
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
                ),
                child: name.isEmpty
                    ? Icon(Icons.person, size: 30, color: colors.iconSecondary)
                    : Center(
                        child: Text(
                          getInitials(name),
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight(500),
                            color: colors.textHint,
                          ),
                        ),
                      ),
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
                      border: Border.all(color: colors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        gmailAccaunt,
                        maxLines: 1,
                        style: getterStyle.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: onTap,
            icon: Icon(
              Icons.messenger_outline,
              size: 18,
              color: getterStyle.primaryColor,
            ),
            style: IconButton.styleFrom(
              backgroundColor: getterStyle.dividerColor,
              foregroundColor: getterStyle.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
