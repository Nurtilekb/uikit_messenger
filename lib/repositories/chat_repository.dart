import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uikit/models/chat_model.dart';
import 'package:uikit/repositories/user_repository.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  ChatRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    UserRepository? userRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _userRepository = userRepository ?? UserRepository();

  Stream<List<Chat>> streamChats() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snap) async {
          final chats = <Chat>[];
          for (final doc in snap.docs) {
            final chat = Chat.fromFirestore(doc.data(), doc.id, currentUserId);
            if (chat.name.isEmpty || chat.name == chat.otherUserId) {
              final otherUserName = await _userRepository.getUserName(
                chat.otherUserId,
              );
              chats.add(
                otherUserName != null && otherUserName.isNotEmpty
                    ? chat.copyWith(name: otherUserName)
                    : chat,
              );
            } else {
              chats.add(chat);
            }
          }
          return chats;
        });
  }

  Future<void> deleteChats(List<String> chatIds) async {
    if (chatIds.isEmpty) return;

    for (final chatId in chatIds) {
      final chatDoc = _firestore.collection('chats').doc(chatId);
      final messageSnapshot = await chatDoc.collection('messages').get();
      final batch = _firestore.batch();

      for (final messageDoc in messageSnapshot.docs) {
        batch.delete(messageDoc.reference);
      }
      batch.delete(chatDoc);

      await batch.commit();
    }
  }
}
