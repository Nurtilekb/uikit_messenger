import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { active, archived, deleted }

class Chat extends Equatable {
  final String chatID;
  final String name;
  final String lastMessage;
  final DateTime time;
  final String avatarUrl;
  final int unreadCount;
  final List<String> participantIds;
  final String otherUserId;
  final bool isSelected;
  final ChatStatus status;

  const Chat({
    required this.chatID,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.avatarUrl = '',
    this.unreadCount = 0,
    this.participantIds = const [],
    this.otherUserId = '',
    this.isSelected = false,
    this.status = ChatStatus.active,
  });

  Chat copyWith({
    String? chatID,
    String? name,
    String? lastMessage,
    DateTime? time,
    String? avatarUrl,
    int? unreadCount,
    List<String>? participantIds,
    String? otherUserId,
    bool? isSelected,
    ChatStatus? status,
  }) {
    return Chat(
      chatID: chatID ?? this.chatID,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      participantIds: participantIds ?? this.participantIds,
      otherUserId: otherUserId ?? this.otherUserId,
      isSelected: isSelected ?? this.isSelected,
      status: status ?? this.status,
    );
  }

  factory Chat.fromFirestore(
    Map<String, dynamic> data,
    String chatId,
    String currentUserId,
  ) {
    final participantIds = <String>[];
    if (data['participantIds'] is List) {
      participantIds.addAll(List<String>.from(data['participantIds']));
    }

    String otherId = '';
    if (participantIds.isNotEmpty) {
      otherId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => participantIds.first,
      );
    }

    if (otherId.isEmpty && chatId.contains('_')) {
      final parts = chatId.split('_');
      if (parts.length == 2) {
        otherId = parts.firstWhere(
          (id) => id != currentUserId,
          orElse: () => parts.first,
        );
      }
    }

    final nameValue = (data['name'] as String?)?.trim();
    final displayName = nameValue?.isNotEmpty == true ? nameValue! : otherId;

    DateTime timeValue = DateTime.now();
    final updated = data['updatedAt'];
    if (updated is Timestamp) {
      timeValue = updated.toDate();
    } else if (updated is String) {
      timeValue = DateTime.tryParse(updated) ?? DateTime.now();
    }

    final unreadCountMap = data['unreadCountByUser'];
    int unreadCountValue = 0;
    if (unreadCountMap is Map) {
      final userCount = unreadCountMap[currentUserId];
      if (userCount is int) {
        unreadCountValue = userCount;
      } else if (userCount is String) {
        unreadCountValue = int.tryParse(userCount) ?? 0;
      }
    }

    if (unreadCountValue == 0) {
      unreadCountValue = data['unreadCount'] is int
          ? data['unreadCount'] as int
          : int.tryParse(data['unreadCount']?.toString() ?? '0') ?? 0;
    }

    return Chat(
      chatID: chatId,
      name: displayName,
      lastMessage: data['lastMessage']?.toString() ?? '',
      avatarUrl: data['avatarUrl']?.toString() ?? '',
      unreadCount: unreadCountValue,
      time: timeValue,
      participantIds: participantIds,
      otherUserId: otherId,
      status: (data['status'] == 'archived')
          ? ChatStatus.archived
          : (data['status'] == 'deleted')
          ? ChatStatus.deleted
          : ChatStatus.active,
    );
  }

  @override
  List<Object?> get props => [
    chatID,
    name,
    lastMessage,
    time,
    avatarUrl,
    unreadCount,
    participantIds,
    otherUserId,
    isSelected,
    status,
  ];
}
