class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final String avatar;
  final int unreadCount;
  final bool isOnline;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.avatar = '',
    this.unreadCount = 0,
    this.isOnline = false,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      name: json['name'],
      lastMessage: json['lastMessage'],
      time: json['time'],
      avatar: json['avatar'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'avatar': avatar,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
    };
  }
}
