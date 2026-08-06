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

  try {
    print('resetUnreadCountForChat: resetting $chatId for $currentUserId');

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(chatRef);
      if (!snap.exists) {
        tx.set(chatRef, {
          'unreadCountByUser': {currentUserId: 0},
          'unreadCount': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return;
      }

      final data = snap.data() ?? <String, dynamic>{};
      final Map<String, dynamic> byUser = (data['unreadCountByUser'] is Map)
          ? Map<String, dynamic>.from(data['unreadCountByUser'])
          : <String, dynamic>{};

      byUser[currentUserId] = 0;

      int total = 0;
      byUser.forEach((key, value) {
        if (value is int)
          total += value;
        else if (value is num)
          total += value.toInt();
        else if (value is String)
          total += int.tryParse(value) ?? 0;
      });

      tx.set(chatRef, {
        'unreadCountByUser': byUser,
        'unreadCount': total,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
    print('resetUnreadCountForChat: success $chatId for $currentUserId');
  } catch (e, st) {
    print(
      'resetUnreadCountForChat: error resetting                      $chatId for $currentUserId: $e\n$st',
    );
    rethrow;
  }
}

String buildChatDocId(String userId1, String userId2) {
  final ids = [userId1, userId2]..sort();
  return ids.join('_');
}
