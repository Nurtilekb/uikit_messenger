import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uikit/blocs/theme/theme_cubit.dart';
import 'package:uikit/screens/login_screen.dart';
import 'package:uikit/screens/register_screen.dart';
import 'package:uikit/theme/app_colors.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    // ignore: use_build_context_synchronously
    context.read<ThemeCubit>().setTheme(isDarkMode);
  }

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
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
              "eho".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: colors.textPrimary,
              ),
            ),
            Text(
              "amessagewithout".tr(),
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
                  tabs: [
                    Tab(text: "login".tr()),
                    Tab(text: 'registration'.tr()),
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
