import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/blocs/auth/auth_state.dart';
import 'package:uikit/utils/validators.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/theme/app_colors.dart';
import 'package:uikit/widgets/common_dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.forLogin,
    required this.onLoginTap,
  });
  final Widget forLogin;
  final VoidCallback onLoginTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrEmailController = TextEditingController();
  final _registrpasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _registrEmailController.dispose();
    _registrpasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showLoadingDialog(context);
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('registration_success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 20, 24, bottom),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildInput(
                        'fullname'.tr(),
                        'fullname2'.tr(),
                        _nameController,
                        colors,
                        Validators.validateString,
                        TextInputType.visiblePassword,
                      ),
                      _buildInput(
                        'Email',
                        'your@gmail.com',
                        _registrEmailController,
                        colors,
                        Validators.validateEmail,
                        TextInputType.emailAddress,
                      ),
                      _buildInput(
                        'password'.tr(),
                        'enteryourpassword'.tr(),
                        _registrpasswordController,
                        colors,
                        Validators.validatePassword,
                        TextInputType.visiblePassword,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      _buildSubmitButton(colors, isLoading),
                      const SizedBox(height: 16),
                      _buildDivider(colors),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'alreadyhaveacc'.tr(),
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                          widget.forLogin,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInput(
    String label,
    String hint,
    TextEditingController controller,
    AppColors colors,
    String? Function(String?)? validator,
    TextInputType inputType, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppInputWidget(
        controller: controller,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        filledColor: colors.cardBackground,
        label: label,
        inputType: inputType,
        validator: validator,
        isPasswordField: isPassword,
      ),
    );
  }

  Widget _buildSubmitButton(AppColors colors, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleSignUp(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          shadowColor: colors.primary.withValues(alpha: 0.3),
        ),
        child: Text(
          'createaccaunt'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDivider(AppColors colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or'.tr(),
            style: TextStyle(color: colors.textSecondary, fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: colors.border)),
      ],
    );
  }

  void _handleSignUp(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _registrEmailController.text.trim();
      final password = _registrpasswordController.text.trim();
      context.read<AuthBloc>().add(
        AuthRegisterRequested(email: email, password: password, name: name),
      );
    }
  }
}
