import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {}

class ToggleChatSelection extends ChatEvent {
  final String chatId;
  const ToggleChatSelection(this.chatId);
  @override
  List<Object?> get props => [chatId];
}

class ClearSelection extends ChatEvent {}

class ArchiveSelectedChats extends ChatEvent {}

class DeleteSelectedChats extends ChatEvent {}

class AddChat extends ChatEvent {
  final String name;
  final String lastMessage;
  final DateTime time;

  const AddChat({
    required this.name,
    required this.lastMessage,
    required this.time,
  });

  @override
  List<Object?> get props => [name, lastMessage, time];
}
