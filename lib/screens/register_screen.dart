import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uikit/widgets/app_text_field.dart';
import 'package:uikit/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.forLogin});
  final Widget forLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'fullname2'.tr();
                }
              },
            ),
            const SizedBox(height: 16),
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
            ),

            const SizedBox(height: 16),
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
              label: 'password'.tr(),
              inputType: TextInputType.visiblePassword,
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

            const SizedBox(height: 70),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
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
            const SizedBox(height: 24),

            Row(
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
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
