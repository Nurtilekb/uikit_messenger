import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/blocs/presence/presence_cubit.dart';

import 'package:uikit/repositories/auth_repository.dart';
import 'package:uikit/blocs/theme/theme_cubit.dart';
import 'package:uikit/firebase_options.dart';
import 'package:uikit/router/app_router.dart';

import 'package:uikit/theme/app_theme.dart';

import 'blocs/auth/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('ky')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  final PresenceService _presenceService = PresenceService();

  @override
  void initState() {
    super.initState();
    _presenceService.initialize();
  }

  @override
  void dispose() {
    _presenceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) {
            return AuthBloc(
              authRepository: AuthRepository(
                googleServerClientId:
                    '317189993499-bfk3q30ilqubtabp6m5sgpi3fogtujh8.apps.googleusercontent.com',
              ),
              presenceService: _presenceService,
            )..add(AuthRestoreRequested());
          },
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GetUserLoading) {
            Center(child: CircularProgressIndicator());
          } else {
            SizedBox();
          }
          if (state is AuthAuthenticated) {
            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            if (currentUserId != null) {
              unawaited(_presenceService.setOnline(currentUserId));
            }
            _appRouter.replaceAll([const HomeRoute()]);
          } else if (state is AuthUnauthenticated) {
            _appRouter.replaceAll([const AuthRoute()]);
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              routerConfig: _appRouter.config(),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
      ),
    );
  }
}
