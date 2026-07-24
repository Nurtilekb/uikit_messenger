import 'package:flutter/material.dart';
import 'package:uikit/screens/login_screen.dart';
import 'package:uikit/screens/register_screen.dart';
import 'package:uikit/theme/app_colors.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                child: TabBar(
                  padding: EdgeInsets.all(5),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: colors.tabSelected,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: colors.primary,
                  unselectedLabelColor: colors.tabUnselected,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'interTight',
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'interTight',
                  ),
                  splashBorderRadius: BorderRadius.circular(16),
                  tabs: const [
                    Tab(text: 'Вход'),
                    Tab(text: 'Регистрация'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
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
