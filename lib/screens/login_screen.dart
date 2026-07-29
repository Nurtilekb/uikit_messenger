import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.router.replace(HomeRoute());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final colors = context.appColors;
    return ElevatedButton(
      onPressed: () => _handleLogin(),

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

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Заполните все поля')));
      return;
    }

    context.read<AuthBloc>().add(
      AuthLoginRequested(email: email, password: password),
    );
  }
}
