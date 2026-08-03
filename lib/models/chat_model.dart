import 'package:equatable/equatable.dart';

enum ChatStatus { active, archived, deleted }

class Chat extends Equatable {
  final String chatID;
  final String name;
  final String lastMessage;
  final DateTime time;
  final bool isSelected;
  final ChatStatus status;

  const Chat({
    required this.chatID,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.isSelected = false,
    this.status = ChatStatus.active,
  });

  Chat copyWith({
    String? chatID,
    String? name,
    String? lastMessage,
    DateTime? time,
    bool? isSelected,
    ChatStatus? status,
    String? avatarUrl,
  }) {
    return Chat(
      chatID: chatID ?? this.chatID,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      isSelected: isSelected ?? this.isSelected,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    chatID,
    name,
    lastMessage,
    time,
    isSelected,
    status,
  ];
}
