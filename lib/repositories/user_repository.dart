import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uikit/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final Map<String, UserModel> _cache = {};

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

  Future<UserModel?> getUserById(String id) async {
    if (id.isEmpty) return null;
    if (_cache.containsKey(id)) return _cache[id];

    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      final user = UserModel.fromJson({...doc.data()!, 'id': doc.id});
      _cache[id] = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserName(String id) async {
    final user = await getUserById(id);
    return user?.name;
  }
}
