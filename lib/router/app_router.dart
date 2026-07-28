import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uikit/screens/auth_view.dart';
import 'package:uikit/screens/chats_screen.dart';
import 'package:uikit/screens/home_screen.dart';
import 'package:uikit/screens/profile_screen.dart';
import 'package:uikit/screens/search_users_screen.dart';
import 'package:uikit/screens/users_list_screen.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    //     AutoRoute(
    //     page: HomeRoute.page,
    //     guards: [

    //         AuthGuard(),

    //     ],
    // )
    AutoRoute(page: AuthRoute.page),
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: SearchRoute.page),
    AutoRoute(page: UsersListRoute.page),
    AutoRoute(page: ChatsRoute.page),
  ];
}
