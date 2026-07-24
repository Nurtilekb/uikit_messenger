import 'package:flutter/material.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String ChatName;
  final bool isOnline;
  final String avatarUrl;

  const UserAppBar({
    super.key,
    required this.ChatName,
    required this.isOnline,
    required this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      actionsPadding: const EdgeInsets.only(right: 8),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black45, size: 28),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert_outlined,
            size: 29,
            color: Colors.black45,
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
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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
                  ChatName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                isOnline ? 'в сети' : 'был(а) недавно',
                style: TextStyle(
                  fontSize: 14,
                  color: isOnline ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
