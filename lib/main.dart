import 'package:flutter/material.dart';
import 'package:uikit/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff0A84FF),
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xff0A84FF)),
          ),
        ),
        dividerColor: const Color.fromARGB(17, 0, 0, 0),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 15),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight(400),
            color: Color.fromARGB(158, 10, 10, 10),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
