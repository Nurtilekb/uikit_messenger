import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uikit/blocs/auth/auth_bloc.dart';
import 'package:uikit/blocs/auth/auth_event.dart';
import 'package:uikit/utils/validators.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/theme/app_colors.dart';

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
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 20, 24, bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const SizedBox(height: 16),
              AppInputWidget(
                controller: _nameController,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                hintText: 'fullname2'.tr(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                filledColor: colors.cardBackground,
                label: 'fullname'.tr(),
                inputType: TextInputType.visiblePassword,
                validator: Validators.validateString,
              ),
              AppInputWidget(
                controller: _registrEmailController,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                hintText: 'your@gmail.com',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                filledColor: colors.cardBackground,
                label: 'Email',
                inputType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),

              AppInputWidget(
                isPasswordField: true,
                controller: _registrpasswordController,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                hintText: 'enteryourpassword'.tr(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                filledColor: colors.cardBackground,
                validator: Validators.validatePassword,
                label: 'password'.tr(),
                inputType: TextInputType.visiblePassword,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleSignUp(context),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(child: Divider(color: colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or'.tr(),
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: colors.border)),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'alreadyhaveacc'.tr(),
                    style: TextStyle(color: colors.textSecondary, fontSize: 15),
                  ),
                  widget.forLogin,
                ],
              ),
            ],
          ),
        ),
      ),
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
