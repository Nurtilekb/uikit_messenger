import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  const SignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });
  @override
  List<Object?> get props => [email, password, fullName];
}

class SignInSucces extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;
  const AuthUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}
