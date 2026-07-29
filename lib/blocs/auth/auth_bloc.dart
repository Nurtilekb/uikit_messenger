import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    _userSubscription = _authService.authStateChanges.listen((user) {
      add(AuthUserChanged(user));
    });

    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
    on<AuthUserChanged>(_onUserChanged);
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signIn(event.email, event.password);
      if (credential.user != null) {
        emit(Authenticated(credential.user!));
      }
    } catch (e) {
      emit(AuthError('Ошибка авторизации: ${e.toString()}'));
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signUp(
        event.email,
        event.password,
        event.fullName,
      );
      if (credential.user != null) {
        emit(Authenticated(credential.user!));
      }
    } catch (e) {
      emit(AuthError('Ошибка регистрации: ${e.toString()}'));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.signOut();
    emit(Unauthenticated());
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    return super.close();
  }
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUp(
    String email,
    String password,
    String fullname,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(fullname);

    await credential.user?.reload();

    return credential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
}
