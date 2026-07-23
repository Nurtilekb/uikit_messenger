import 'package:flutter/material.dart';
import 'package:uikit/screens/login_screen.dart';
import 'package:uikit/screens/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSocialIcon(Icons.messenger),
            const SizedBox(height: 16),
            const Text(
              'Эхо',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: Colors.black,
              ),
            ),
            Text(
              'Сообщения без лишнего',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
                color: const Color.fromARGB(95, 10, 10, 10),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(44, 158, 158, 158),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: selectedIndex == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 164,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                                _pageController.animateToPage(
                                  0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                'Вход',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: selectedIndex == 0
                                      ? Color(0xff0A84FF)
                                      : Color.fromARGB(95, 10, 10, 10),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'interTight',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                                _pageController.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                'Регистрация',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: selectedIndex == 1
                                      ? Color(0xff0A84FF)
                                      : Color.fromARGB(95, 10, 10, 10),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'interTight',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: [LoginScreen(), RegisterScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          color: const Color(0xff0A84FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(134, 10, 132, 255), // Цвет тени
              blurRadius: 10, // Размытие
              offset: Offset(0, 7), // Смещение вниз (0 по X, 4 по Y)
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: Colors.white),
      ),
    );
  }
}
