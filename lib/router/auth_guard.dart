import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
    } else if (authState is AuthLoading) {
      _showLoadingAndWait(resolver, router);
    } else {
      router.replace(const AuthRoute());
    }
  }

  void _showLoadingAndWait(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;
    if (context == null) {
      resolver.next();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final authBloc = context.read<AuthBloc>();
    StreamSubscription<dynamic>? subscription;

    subscription = authBloc.stream.listen((state) {
      if (state is AuthAuthenticated) {
        subscription?.cancel();
        context.router.push(const HomeRoute());
        resolver.next();
      } else if (state is AuthUnauthenticated || state is AuthError) {
        subscription?.cancel();
        context.router.pop();
        router.replace(const AuthRoute());
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      subscription?.cancel();
      context.router.pop();
      if (!resolver.isResolved) {
        router.replace(const AuthRoute());
      }
    });
  }
}
