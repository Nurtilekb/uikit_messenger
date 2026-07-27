import 'package:flutter/material.dart';
import 'package:uikit/theme/app_colors.dart';

class SearchChatTile extends StatelessWidget {
  final String name;
  final String gmailAccaunt;
  final String avatarUrl;
  final VoidCallback? onTap;

  const SearchChatTile({
    super.key,
    required this.name,
    required this.gmailAccaunt,
    required this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final getterStyle = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 65,
                height: 65,
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
                          fontSize: 16,
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
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline, size: 18),
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
