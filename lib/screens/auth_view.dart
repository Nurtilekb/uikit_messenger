import 'package:flutter/material.dart';
import 'package:uikit/screens/login_screen.dart';
import 'package:uikit/screens/register_screen.dart';
import 'package:uikit/theme/app_colors.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSocialIcon(Icons.messenger),
            const SizedBox(height: 16),
            Text(
              'Эхо',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: colors.textPrimary,
              ),
            ),
            Text(
              'Сообщения без лишнего',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: colors.tabBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: selectedIndex == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 164,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colors.tabSelected,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
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
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                'Вход',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: selectedIndex == 0
                                      ? colors.primary
                                      : colors.tabUnselected,
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
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                'Регистрация',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: selectedIndex == 1
                                      ? colors.primary
                                      : colors.tabUnselected,
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
                children: const [LoginScreen(), RegisterScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    final colors = context.appColors;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: colors.textOnPrimary),
      ),
    );
  }
}
