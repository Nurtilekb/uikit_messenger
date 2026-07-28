// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String avatar;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isOnline,
  });
}
