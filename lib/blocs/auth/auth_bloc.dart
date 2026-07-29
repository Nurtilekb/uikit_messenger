import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/blocs/auth/auth_repository.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required this._authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRestoreRequested>(_onRestore);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final user = _authRepository.currentUser;
    if (user != null) {
      final userModel = await _authRepository.getUserData(user.uid);
      if (userModel != null) {
        emit(AuthAuthenticated(user: userModel));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        final userModel = await _authRepository.getUserData(user.id);
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthAuthenticated(user: user));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        final userModel = await _authRepository.getUserData(user.id);
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthAuthenticated(user: user));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRestore(
    AuthRestoreRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _authRepository.currentUser;

      if (user != null) {
        final userModel = await _authRepository.getUserData(user.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          final tempUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'User',
            email: user.email ?? '',
            avatar: user.photoURL ?? '',
            isOnline: true,
            createdAt: DateTime.now(),
          );
          emit(AuthAuthenticated(user: tempUser));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
