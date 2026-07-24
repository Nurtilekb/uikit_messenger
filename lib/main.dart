import 'package:flutter/material.dart';
import 'package:uikit/screens/home_screen.dart';
import 'package:uikit/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(),
    );
  }
}
