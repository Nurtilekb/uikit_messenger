// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [ChatsScreen]
class ChatsRoute extends PageRouteInfo<ChatsRouteArgs> {
  ChatsRoute({
    Key? key,
    required String numName,
    required bool isOnline,
    required String imageAvatar,
    List<PageRouteInfo>? children,
  }) : super(
         ChatsRoute.name,
         args: ChatsRouteArgs(
           key: key,
           numName: numName,
           isOnline: isOnline,
           imageAvatar: imageAvatar,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatsRouteArgs>();
      return ChatsScreen(
        key: args.key,
        numName: args.numName,
        isOnline: args.isOnline,
        imageAvatar: args.imageAvatar,
      );
    },
  );
}

class ChatsRouteArgs {
  const ChatsRouteArgs({
    this.key,
    required this.numName,
    required this.isOnline,
    required this.imageAvatar,
  });

  final Key? key;

  final String numName;

  final bool isOnline;

  final String imageAvatar;

  @override
  String toString() {
    return 'ChatsRouteArgs{key: $key, numName: $numName, isOnline: $isOnline, imageAvatar: $imageAvatar}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatsRouteArgs) return false;
    return key == other.key &&
        numName == other.numName &&
        isOnline == other.isOnline &&
        imageAvatar == other.imageAvatar;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      numName.hashCode ^
      isOnline.hashCode ^
      imageAvatar.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({Key? key, required String name, List<PageRouteInfo>? children})
    : super(
        ProfileRoute.name,
        args: ProfileRouteArgs(key: key, name: name),
        initialChildren: children,
      );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>();
      return ProfileScreen(key: args.key, name: args.name);
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key, required this.name});

  final Key? key;

  final String name;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileRouteArgs) return false;
    return key == other.key && name == other.name;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode;
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchScreen();
    },
  );
}

/// generated route for
/// [UsersListScreen]
class UsersListRoute extends PageRouteInfo<void> {
  const UsersListRoute({List<PageRouteInfo>? children})
    : super(UsersListRoute.name, initialChildren: children);

  static const String name = 'UsersListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UsersListScreen();
    },
  );
}
