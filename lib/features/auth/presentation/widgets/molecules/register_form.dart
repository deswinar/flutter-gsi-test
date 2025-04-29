import 'package:flutter/material.dart';
import 'package:keanggotaan/shared/widgets/atoms/custom_text_field.dart';
import '../../../../../shared/widgets/atoms/primary_button.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onRegister;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(label: 'Email', controller: emailController, hint: 'Email', keyboardType: TextInputType.emailAddress,),
        const SizedBox(height: 12),
        CustomTextField(label: 'Password', obscureText: true, controller: passwordController, hint: 'Password', keyboardType: TextInputType.visiblePassword,),
        const SizedBox(height: 20),
        PrimaryButton(label: 'Sign Up', onPressed: onRegister),
      ],
    );
  }
}