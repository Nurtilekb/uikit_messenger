import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/router/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context == null) {
      resolver.next();
      return;
    }

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      resolver.next();
      return;
    }

    if (authState is AuthLoading) {
      late final StreamSubscription<AuthState> subscription;
      subscription = context.read<AuthBloc>().stream.listen((state) {
        subscription.cancel();
        if (state is AuthAuthenticated) {
          resolver.next();
        } else {
          router.replace(const AuthRoute());
        }
      });
      return;
    }

    router.replace(const AuthRoute());
  }
}
