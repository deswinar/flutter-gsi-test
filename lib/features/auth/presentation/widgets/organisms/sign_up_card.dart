import 'package:flutter/material.dart';
import '../atoms/app_logo.dart';
import '../molecules/register_footer.dart';
import '../molecules/register_form.dart';

class SignUpCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const SignUpCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(),
            const SizedBox(height: 24),
            RegisterForm(
              emailController: emailController,
              passwordController: passwordController,
              onRegister: onRegister,
            ),
            const SizedBox(height: 24),
            RegisterFooter(onLogin: onLogin),
          ],
        ),
      ),
    );
  }
}