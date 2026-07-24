import 'package:flutter/material.dart';
import 'package:uikit/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _scroolController = ScrollController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scroolController,
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
            filledColor: Colors.white,
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
            filledColor: Colors.white,
            controller: _passwordController,
            label: 'Пароль',
            hintText: 'Введите пароль',
            isPasswordField: true,
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
          const SizedBox(height: 24),
          _buildSignInButton(context),
          const SizedBox(height: 20),
          _buildForgotPasswordButton(context),
          const SizedBox(height: 20),
          _buildSocialIcon(Icons.g_mobiledata, 'Google'),
          const SizedBox(height: 20),
          _buildSignUpRow(context),
        ],
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        'Войти',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(height: 1, color: Color.fromARGB(40, 10, 10, 10)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Text('или'),
        ),
        Expanded(
          child: Divider(height: 1, color: Color.fromARGB(40, 10, 10, 10)),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: ColoredBox(
                color: Colors.black12,
                child: Icon(icon, size: 28, color: Colors.grey[800]),
              ),
            ),
            SizedBox(width: 20),
            Text(
              "Войти через Google",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Забыли пароль?",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Восстановить',
            style: TextStyle(
              color: Color(0xFF0066FF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
