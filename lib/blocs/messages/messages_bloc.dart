import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uikit/repositories/message_repository.dart';
import 'messages_event.dart';
import 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessageRepository _repository;
  final FirebaseAuth _auth;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _messagesSubscription;

  MessagesBloc({MessageRepository? repository, FirebaseAuth? auth})
    : _repository = repository ?? MessageRepository(),
      _auth = auth ?? FirebaseAuth.instance,
      super(MessagesInitial()) {
    on<SendMessage>(_onSendMessage);
    on<MarkChatRead>(_onMarkChatRead);
    on<SubscribeMessages>(_onSubscribeMessages);
    on<UnsubscribeMessages>(_onUnsubscribeMessages);
    on<DeleteMessages>(_onDeleteMessages);
    on<ClearChat>(_onClearChat);
    on<_InternalMessagesUpdated>(
      (event, emit) => _onInternalMessagesUpdated(event.docs, emit),
    );
    on<_InternalMessagesError>(
      (event, emit) => _onInternalMessagesError(event.error, emit),
    );
  }

  FutureOr<void> _onSendMessage(
    SendMessage event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessageSending());
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) throw Exception('No current user');

      await _repository.sendMessage(
        chatId: event.chatId,
        senderId: currentUserId,
        recipientId: event.recipientId,
        text: event.text,
      );

      emit(MessageSent());
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  FutureOr<void> _onMarkChatRead(
    MarkChatRead event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      await _repository.markChatRead(
        chatId: event.chatId,
        currentUserId: event.currentUserId,
      );
    } catch (_) {}
  }

  FutureOr<void> _onSubscribeMessages(
    SubscribeMessages event,
    Emitter<MessagesState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    emit(MessagesLoadInProgress());
    _messagesSubscription = _repository
        .streamMessages(chatId: event.chatId)
        .listen(
          (snap) {
            add(_InternalMessagesUpdated(snap.docs));
          },
          onError: (e) {
            add(_InternalMessagesError(e.toString()));
          },
        );
  }

  FutureOr<void> _onUnsubscribeMessages(
    UnsubscribeMessages event,
    Emitter<MessagesState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    _messagesSubscription = null;
    emit(MessagesInitial());
  }

  FutureOr<void> _onDeleteMessages(
    DeleteMessages event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      await _repository.deleteMessages(
        chatId: event.chatId,
        messageIds: event.messageIds,
      );
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  FutureOr<void> _onClearChat(
    ClearChat event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      await _repository.clearChat(
        chatId: event.chatId,
        currentUserId: event.currentUserId,
      );
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  void _onInternalMessagesUpdated(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    Emitter<MessagesState> emit,
  ) {
    emit(MessagesLoadSuccess(docs));
  }

  void _onInternalMessagesError(String error, Emitter<MessagesState> emit) {
    emit(MessageError(error));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}

class _InternalMessagesUpdated extends MessagesEvent {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  const _InternalMessagesUpdated(this.docs);
  @override
  List<Object?> get props => [docs];
}

class _InternalMessagesError extends MessagesEvent {
  final String error;
  const _InternalMessagesError(this.error);
  @override
  List<Object?> get props => [error];
}
