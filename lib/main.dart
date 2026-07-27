import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/screens/home_screen.dart';
import 'package:uikit/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('en'), Locale('ky')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ky'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(),
    );
  }
}
