import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uikit/models/chat_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  Stream<List<Chat>> streamChats() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs.map((doc) {
            final data = doc.data();
            final participantIds = <String>[];
            if (data['participantIds'] is List) {
              participantIds.addAll(List<String>.from(data['participantIds']));
            }
            final participantNames = <String, dynamic>{};
            if (data['participantNames'] is Map) {
              participantNames.addAll(
                Map<String, dynamic>.from(data['participantNames']),
              );
            }

            String otherId = '';
            if (participantIds.isNotEmpty) {
              otherId = participantIds.firstWhere(
                (id) => id != currentUserId,
                orElse: () => participantIds.first,
              );
            }

            final name = participantNames[otherId]?.toString() ?? otherId;
            final lastMessage = data['lastMessage']?.toString() ?? '';

            DateTime time = DateTime.now();
            final updated = data['updatedAt'];
            if (updated is Timestamp) {
              time = updated.toDate();
            } else if (updated is String) {
              time = DateTime.tryParse(updated) ?? DateTime.now();
            }

            return Chat(
              chatID: doc.id,
              name: name,
              lastMessage: lastMessage,
              time: time,
            );
          }).toList();
        });
  }
}
