import 'package:flutter/material.dart';

class Search_User_Tile extends StatelessWidget {
  final String name;
  final String gmailAccaunt;
  final String avatarUrl;
  final VoidCallback? onTap;

  const Search_User_Tile({
    super.key,
    required this.name,
    required this.gmailAccaunt,
    required this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final _getterStyle = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: avatarUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: avatarUrl.isEmpty
                      ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                      : null,
                ),
              ],
            ),
            const SizedBox(width: 14),

            // User info
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

                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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
                          style: _getterStyle.textTheme.bodySmall,
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
                backgroundColor: _getterStyle.dividerColor,
                foregroundColor: _getterStyle.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
