import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uikit/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<List<UserModel>> getUsers() async {
    try {
      final currentUserId = _firebaseAuth.currentUser?.uid;
      final snapshot = await _firestore.collection('users').get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .where((user) => currentUserId == null || user.id != currentUserId)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
