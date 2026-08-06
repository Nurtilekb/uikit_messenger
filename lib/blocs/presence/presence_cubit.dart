import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PresenceService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final Connectivity _connectivity;

  StreamSubscription? _authSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;
  String? _currentUserId;

  PresenceService({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
    Connectivity? connectivity,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _connectivity = connectivity ?? Connectivity();

  void initialize() {
    log('PresenceService: Initializing...');

    _authSubscription = _firebaseAuth.authStateChanges().listen((user) async {
      if (user != null) {
        log('PresenceService: User authenticated - ${user.uid}');
        await syncPresence(user.uid);
      } else {
        log('PresenceService: User logged out');
        if (_currentUserId != null) {
          await _setOnlineStatus(_currentUserId!, false);
        }
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) async {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) return;
      final hasConnection = !results.contains(ConnectivityResult.none);
      await _setOnlineStatus(userId, hasConnection);
    });

    syncPresence(_firebaseAuth.currentUser?.uid);
  }

  Future<void> _setOnlineStatus(String userId, bool isOnline) async {
    if (_isOnline == isOnline && _currentUserId == userId) {
      return;
    }

    try {
      log('PresenceService: Setting $userId isOnline=$isOnline');

      await _firestore.collection('users').doc(userId).set({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _isOnline = isOnline;
      _currentUserId = isOnline ? userId : null;
    } catch (e, stackTrace) {
      log(
        'PresenceService: Failed to update presence',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setOnline(String userId) async {
    await _setOnlineStatus(userId, true);
  }

  Future<void> setOffline(String userId) async {
    await _setOnlineStatus(userId, false);
  }

  bool get isOnline => _isOnline;

  Future<bool> syncPresence(String? userId) async {
    if (userId == null) return false;

    final results = await _connectivity.checkConnectivity();
    final hasConnection = !results.contains(ConnectivityResult.none);
    await _setOnlineStatus(userId, hasConnection);
    return hasConnection;
  }

  void dispose() {
    log('PresenceService: Disposing...');

    if (_isOnline && _currentUserId != null) {
      _setOnlineStatus(_currentUserId!, false).catchError((e) {
        log('PresenceService: Failed to set offline on dispose', error: e);
      });
    }

    _authSubscription?.cancel();
    _authSubscription = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
