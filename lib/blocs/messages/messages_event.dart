import 'package:equatable/equatable.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();
  @override
  List<Object?> get props => [];
}

class SendMessage extends MessagesEvent {
  final String chatId;
  final String recipientId;
  final String text;

  const SendMessage({
    required this.chatId,
    required this.recipientId,
    required this.text,
  });

  @override
  List<Object?> get props => [chatId, recipientId, text];
}

class MarkChatRead extends MessagesEvent {
  final String chatId;
  final String currentUserId;

  const MarkChatRead({required this.chatId, required this.currentUserId});

  @override
  List<Object?> get props => [chatId, currentUserId];
}

class UnsubscribeMessages extends MessagesEvent {
  final String chatId;

  const UnsubscribeMessages({required this.chatId});
}

class SubscribeMessages extends MessagesEvent {
  final String chatId;

  const SubscribeMessages({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class DeleteMessages extends MessagesEvent {
  final String chatId;
  final List<String> messageIds;

  const DeleteMessages({required this.chatId, required this.messageIds});

  @override
  List<Object?> get props => [chatId, messageIds];
}

class ClearChat extends MessagesEvent {
  final String chatId;
  final String currentUserId;

  const ClearChat({required this.chatId, required this.currentUserId});

  @override
  List<Object?> get props => [chatId, currentUserId];
}
