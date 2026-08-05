import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();
  @override
  List<Object?> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessageSending extends MessagesState {}

class MessageSent extends MessagesState {}

class MessageError extends MessagesState {
  final String message;
  const MessageError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessagesLoadInProgress extends MessagesState {}

class MessagesLoadSuccess extends MessagesState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  const MessagesLoadSuccess(this.docs);

  @override
  List<Object?> get props => [docs];
}
