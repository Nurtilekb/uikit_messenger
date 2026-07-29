import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/router/app_router.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SingleChildScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          AppInputWidget(
            labelStyle: Theme.of(context).textTheme.bodySmall,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            filledColor: colors.cardBackground,
            controller: _emailController,
            label: 'Email',
            hintText: 'your@gmail.com',
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AppInputWidget(
            labelStyle: Theme.of(context).textTheme.bodySmall,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            filledColor: colors.cardBackground,
            controller: _passwordController,
            label: 'password'.tr(),
            hintText: 'enteryourpassword'.tr(),
            isPasswordField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'enteryourpassword'.tr();
              }
              if (value.length < 6) {
                return '6characterspassword'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildSignInButton(context),
          const SizedBox(height: 20),
          _buildForgotPasswordButton(context),
          const SizedBox(height: 20),
          _buildSocialIcon(Icons.g_mobiledata, 'Google'),
          const SizedBox(height: 20),
          // _buildSignUpRow(context),
        ],
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final colors = context.appColors;
    return ElevatedButton(
      onPressed: () => _handleSignIn(context),

      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primaryDark,
        foregroundColor: colors.textOnPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        "login".tr(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Expanded(child: Divider(height: 1, color: colors.divider)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("or".tr(), style: TextStyle(color: colors.textSecondary)),
        ),
        Expanded(child: Divider(height: 1, color: colors.divider)),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    final colors = context.appColors;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 56,
        decoration: BoxDecoration(
          color: colors.googleButtonBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.googleButtonBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: ColoredBox(
                color: colors.surface,
                child: Icon(icon, size: 28, color: colors.googleButtonIcon),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "signinwithGoogle".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignIn(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Проверка полей
    final emailError = _validateEmail(email);
    if (emailError != null) {
      _showSnackBar(context, emailError, Colors.red);
      return;
    }

    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      _showSnackBar(context, passwordError, Colors.red);
      return;
    }

    // Отправляем событие в Bloc
    context.read<AuthBloc>().add(
      SignInRequested(email: email, password: password),
    );
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.red ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
