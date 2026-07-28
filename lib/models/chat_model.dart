// lib/models/chat_model.dart
import 'package:equatable/equatable.dart';
import 'user_model.dart';

enum ChatType { direct, group }

class ChatModel extends Equatable {
  final String id;
  final String name;
  final ChatType type;
  final List<String> participantIds;
  final List<UserModel>? participants;
  final String? lastMessageId;
  final String? lastMessageText;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final int unreadCount;
  final bool isGroup;
  final String? avatar;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ChatModel({
    required this.id,
    required this.name,
    this.type = ChatType.direct,
    this.participantIds = const [],
    this.participants,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isGroup = false,
    this.avatar,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] == 'group' ? ChatType.group : ChatType.direct,
      participantIds: List<String>.from(json['participantIds'] ?? []),
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((p) => UserModel.fromJson(p))
              .toList()
          : null,
      lastMessageId: json['lastMessageId'],
      lastMessageText: json['lastMessageText'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      lastMessageSenderId: json['lastMessageSenderId'],
      unreadCount: json['unreadCount'] ?? 0,
      isGroup: json['isGroup'] ?? false,
      avatar: json['avatar'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type == ChatType.group ? 'group' : 'direct',
      'participantIds': participantIds,
      'participants': participants?.map((p) => p.toJson()).toList(),
      'lastMessageId': lastMessageId,
      'lastMessageText': lastMessageText,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isGroup': isGroup,
      'avatar': avatar,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    String? name,
    ChatType? type,
    List<String>? participantIds,
    List<UserModel>? participants,
    String? lastMessageId,
    String? lastMessageText,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isGroup,
    String? avatar,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      avatar: avatar ?? this.avatar,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedLastMessageTime {
    if (lastMessageTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(lastMessageTime!);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    
    return '${lastMessageTime!.day}/${lastMessageTime!.month}/${lastMessageTime!.year}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        participantIds,
        participants,
        lastMessageId,
        lastMessageText,
        lastMessageTime,
        lastMessageSenderId,
        unreadCount,
        isGroup,
        avatar,
        createdBy,
        createdAt,
        updatedAt,
      ];
}
