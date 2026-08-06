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

    // ignore: avoid_print
    print(
      'sendMessage: chat=$chatId sender=$senderId recipient=$recipientId text=$text',
    );

    await chatDocRef.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'sendAt':
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update chat metadata and unread counters
    final updateData = {
      'participantIds': [senderId, recipientId],
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
      'senderId': senderId,
      'unreadCount': FieldValue.increment(1),
      'unreadCountByUser': {senderId: 0, recipientId: FieldValue.increment(1)},
    };
    // ignore: avoid_print
    print('sendMessage: updating chat doc $chatId with $updateData');

    await chatDocRef.set(updateData, SetOptions(merge: true));
  }

  Future<void> markChatRead({
    required String chatId,
    required String currentUserId,
  }) async {
    await _firestore.collection('chats').doc(chatId).set({
      'unreadCountByUser.$currentUserId': 0,
      'unreadCount': 0,
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

  Future<void> clearChat({
    required String chatId,
    required String currentUserId,
  }) async {
    final chatDoc = _firestore.collection('chats').doc(chatId);
    final chatSnapshot = await chatDoc.get();
    final participantIds = <String>[];
    final data = chatSnapshot.data();
    if (data != null && data['participantIds'] is List) {
      participantIds.addAll(List<String>.from(data['participantIds']));
    }

    final messagesRef = chatDoc.collection('messages');
    final messageSnapshot = await messagesRef.get();
    final batch = _firestore.batch();

    for (final messageDoc in messageSnapshot.docs) {
      batch.delete(messageDoc.reference);
    }

    final unreadMap = <String, Object>{};
    for (final participantId in participantIds) {
      unreadMap[participantId] = 0;
    }
    if (participantIds.isEmpty && currentUserId.isNotEmpty) {
      unreadMap[currentUserId] = 0;
    }

    batch.set(chatDoc, {
      'lastMessage': '',
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadCountByUser': unreadMap,
    }, SetOptions(merge: true));

    await batch.commit();
  }
}
