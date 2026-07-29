import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_repository.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/blocs/theme/theme_cubit.dart';
import 'package:uikit/firebase_options.dart';
import 'package:uikit/router/app_router.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: appRouter.config(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      router.replace(const AuthRoute());
      return;
    }

    // Проверяем профиль в Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((doc) {
          if (doc.exists && doc.data()?['name'] != null) {
            resolver.next(); // Профиль заполнен
          } else {
            router.replace(const ProfileRoute()); // Профиль не заполнен
          }
        })
        .catchError((e) {
          // Если ошибка - пропускаем (или редирект на Auth)
          resolver.next();
        });
  }
}
