import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uikit/models/chat_model.dart';

import 'chats_event.dart';
import 'chats_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<AddChat>(_onAddChat);
    on<ToggleChatSelection>(_onToggleSelection);
    on<ClearSelection>(_onClearSelection);
    on<ArchiveSelectedChats>(
      _onArchiveSelected as EventHandler<ArchiveSelectedChats, ChatState>,
    );
    on<DeleteSelectedChats>(
      _onDeleteSelected as EventHandler<DeleteSelectedChats, ChatState>,
    );
  }

  FutureOr<void> _onToggleSelection(
    ToggleChatSelection event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedChats = currentState.chats.map((chat) {
        if (chat.chatID == event.chatId) {
          return chat.copyWith(isSelected: !chat.isSelected);
        }
        return chat;
      }).toList();

      final selectedCount = updatedChats.where((c) => c.isSelected).length;
      emit(ChatLoaded(chats: updatedChats, selectedCount: selectedCount));
    }
  }

  FutureOr<void> _onClearSelection(
    ClearSelection event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedChats = currentState.chats
          .map((chat) => chat.copyWith(isSelected: false))
          .toList();
      emit(ChatLoaded(chats: updatedChats, selectedCount: 0));
    }
  }

  FutureOr<void> _onArchiveSelected(
    ClearSelection event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedChats = currentState.chats.map((chat) {
        if (chat.isSelected) {
          return chat.copyWith(status: ChatStatus.archived, isSelected: false);
        }
        return chat;
      }).toList();

      final visibleChats = updatedChats
          .where((c) => c.status == ChatStatus.active)
          .toList();
      emit(ChatLoaded(chats: visibleChats, selectedCount: 0));
    }
  }

  FutureOr<void> _onDeleteSelected(
    ClearSelection event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedChats = currentState.chats.map((chat) {
        if (chat.isSelected) {
          return chat.copyWith(status: ChatStatus.deleted, isSelected: false);
        }
        return chat;
      }).toList();

      final visibleChats = updatedChats
          .where((c) => c.status == ChatStatus.active)
          .toList();
      emit(ChatLoaded(chats: visibleChats, selectedCount: 0));
    }
  }

  FutureOr<void> _onAddChat(event, Emitter<ChatState> emit) {}
}
