import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String recipientId,
    required String text,
  }) async {
    final chatDocRef = _firestore.collection('chats').doc(chatId);

    await chatDocRef.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'sendAt':
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await chatDocRef.set({
      'participantIds': [senderId, recipientId],
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
      'senderId': senderId,
      'unreadCountByUser.$recipientId': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> markChatRead({
    required String chatId,
    required String currentUserId,
  }) async {
    await _firestore.collection('chats').doc(chatId).set({
      'unreadCountByUser.$currentUserId': 0,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessages({
    required String chatId,
  }) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots(includeMetadataChanges: true);
  }

  Future<void> deleteMessages({
    required String chatId,
    required List<String> messageIds,
  }) async {
    if (messageIds.isEmpty) return;

    final chatDoc = _firestore.collection('chats').doc(chatId);
    final messagesRef = chatDoc.collection('messages');
    final batch = _firestore.batch();

    for (final id in messageIds) {
      batch.delete(messagesRef.doc(id));
    }

    await batch.commit();

    final remainingSnapshot = await messagesRef.get();
    final remainingMessage = remainingSnapshot.docs.isNotEmpty
        ? (remainingSnapshot.docs.last.data()['text']?.toString() ?? '')
        : '';

    await chatDoc.set({
      'lastMessage': remainingMessage,
    }, SetOptions(merge: true));
  }
}
