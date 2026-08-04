import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUnreadCountForChat(
  String chatId,
  String currentUserId,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> newMessages,
) async {
  if (newMessages.isEmpty || currentUserId.isEmpty) return;

  final incomingMessages = newMessages.where((doc) {
    final senderId = doc.data()['senderId']?.toString();
    return senderId != null && senderId != currentUserId;
  }).toList();

  if (incomingMessages.isEmpty) return;

  final chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  await chatDocRef.set({
    'unreadCount': FieldValue.increment(incomingMessages.length),
  }, SetOptions(merge: true));
}

Future<void> resetUnreadCountForChat(String chatId) async {
  await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
    'unreadCount': 0,
  }, SetOptions(merge: true));
}

String buildChatDocId(String userId1, String userId2) {
  final ids = [userId1, userId2]..sort();
  return ids.join('_');
}
