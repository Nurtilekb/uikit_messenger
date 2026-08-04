import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uikit/router/auth_guard.dart';
import 'package:uikit/screens/auth_view.dart';
import 'package:uikit/screens/chats_screen.dart';
import 'package:uikit/screens/home_screen.dart';
import 'package:uikit/screens/profile_screen.dart';
import 'package:uikit/screens/search_users_screen.dart';
import 'package:uikit/screens/splash_screen.dart';
import 'package:uikit/screens/users_list_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard = AuthGuard();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page),

    AutoRoute(page: HomeRoute.page, guards: [authGuard]),
    AutoRoute(page: ProfileRoute.page, guards: [authGuard]),
    AutoRoute(page: SearchRoute.page, guards: [authGuard]),
    AutoRoute(page: UsersListRoute.page, guards: [authGuard]),
    CustomRoute(
      page: ChatsRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
      duration: const Duration(milliseconds: 300),
      guards: [authGuard],
    ),
    AutoRoute(page: SplashRoute.page, initial: true),
  ];
}
