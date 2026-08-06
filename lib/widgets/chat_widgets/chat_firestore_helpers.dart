import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> incrementUnreadCountForChat(
  String chatId,
  String recipientId,
) async {
  if (recipientId.isEmpty) return;

  final chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  await chatDocRef.set({
    'unreadCountByUser.$recipientId': FieldValue.increment(1),
  }, SetOptions(merge: true));
}

Future<void> resetUnreadCountForChat(
  String chatId,
  String currentUserId,
) async {
  if (currentUserId.isEmpty) return;

  await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
    'unreadCountByUser.$currentUserId': 0,
    'unreadCount': 0,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

String buildChatDocId(String userId1, String userId2) {
  final ids = [userId1, userId2]..sort();
  return ids.join('_');
}
