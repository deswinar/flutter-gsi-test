import 'package:flutter/material.dart';
import 'package:keanggotaan/shared/widgets/atoms/custom_text_field.dart';
import '../../../../../shared/widgets/atoms/primary_button.dart';
import '../atoms/text_link.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onForgotPassword,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: 'Email',
          controller: emailController,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Password',
          obscureText: true,
          controller: passwordController,
          hint: 'Password',
          keyboardType: TextInputType.visiblePassword,
        ),
        const SizedBox(height: 12),
        TextLink(text: 'Forgot Password?', onTap: onForgotPassword),
        const SizedBox(height: 20),
        PrimaryButton(
          label: isLoading ? 'Signing In...' : 'Sign In',
          onPressed: isLoading ? null : onLogin,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
