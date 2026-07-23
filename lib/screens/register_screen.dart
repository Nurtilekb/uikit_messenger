import 'package:flutter/material.dart';
import 'package:uikit/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _registrEmailController = TextEditingController();
  final TextEditingController _registrpasswordController =
      TextEditingController();
  final TextEditingController _registrpassword2Controller =
      TextEditingController();

  @override
  void dispose() {
    _registrEmailController.dispose();
    _registrpasswordController.dispose();
    _registrpassword2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            AppInputWidget(
              controller: _registrEmailController,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              hintText: 'your@gmail.com',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              filledColor: Colors.white,
              label: 'Email',
              inputType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),
            AppInputWidget(
              isPasswordField: true,
              controller: _registrpasswordController,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              hintText: 'Введите пароль',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              filledColor: Colors.white,
              label: 'Пароль',
              inputType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите пароль';
                }
                if (value.length < 6) {
                  return 'Пароль должен быть не менее 6 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            AppInputWidget(
              isPasswordField: true,
              controller: _registrpassword2Controller,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              hintText: 'Подтвердите пароль',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              filledColor: Colors.white,
              label: 'Пароль',
              inputType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите пароль';
                }
                if (_registrpasswordController.text !=
                    _registrpassword2Controller.text) {
                  return 'Пароли не совпадают!';
                }
                if (value.length < 6) {
                  return 'Пароль должен быть не менее 6 символов';
                }
                return null;
              },
            ),

            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0A84FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                  shadowColor: Color(0xff0A84FF).withOpacity(0.3),
                ),
                child: Text(
                  'Create Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'или',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),
            const SizedBox(height: 24),

            // Social icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.email_outlined),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.apple),
              ],
            ),
            const SizedBox(height: 32),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xff0A84FF),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }
}
