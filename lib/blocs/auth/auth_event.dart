import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthRestoreRequested extends AuthEvent {
  final String? userId;
  final String? name;

  AuthRestoreRequested({this.userId, this.name});
}

class UpdateProfileRequested extends AuthEvent {
  final String name;

  UpdateProfileRequested({required this.name});
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthGoogleRequested extends AuthEvent {}
