import 'package:equatable/equatable.dart';
import 'package:uikit/models/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;
  final int selectedCount;

  const ChatLoaded({required this.chats, this.selectedCount = 0});

  @override
  List<Object?> get props => [chats, selectedCount];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- BLoC ---
