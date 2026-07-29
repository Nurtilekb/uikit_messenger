import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/blocs/auth/auth_state.dart';

import 'package:uikit/repositories/auth_repository.dart';
import 'package:uikit/blocs/theme/theme_cubit.dart';
import 'package:uikit/firebase_options.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/screens/splash_screen.dart';

import 'package:uikit/theme/app_theme.dart';

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

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (context) {
            final bloc = AuthBloc(authRepository: AuthRepository());
            bloc.add(AuthRestoreRequested());
            return bloc;
          },
        ),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (_appRouter.current.name != HomeRoute.name) {
              _appRouter.replaceAll([const HomeRoute()]);
            }
          } else if (state is AuthUnauthenticated) {
            if (_appRouter.current.name != AuthRoute.name) {
              _appRouter.replaceAll([const AuthRoute()]);
            }
          }
        },
        builder: (context, state) {
          if (state is AuthInitial || state is AuthLoading) {
            return MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: context.watch<ThemeCubit>().state.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const SplashScreen(),
            );
          }

          return MaterialApp.router(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: _appRouter.config(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: context.watch<ThemeCubit>().state.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }
}
