import 'package:flutter/material.dart';
import '../atoms/app_logo.dart';
import '../molecules/login_form.dart';
import '../molecules/login_footer.dart';

class SignInCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;
  final bool isLoading;

  const SignInCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
    this.isLoading = false,
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
            LoginForm(
              emailController: emailController,
              passwordController: passwordController,
              onLogin: onLogin,
              onForgotPassword: onForgotPassword,
              isLoading: isLoading, // <-- pass to form
            ),
            const SizedBox(height: 24),
            LoginFooter(onRegister: onRegister),
          ],
        ),
      ),
    );
  }
}
