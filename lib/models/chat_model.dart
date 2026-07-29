class Chat {
  final String avatar;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String id;

  Chat({
    this.avatar = '',
    this.unreadCount = 0,
    this.isOnline = false,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      avatar: json['avatar'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
    };
  }
}
