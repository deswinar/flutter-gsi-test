import 'package:flutter/material.dart';
import '../atoms/text_link.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback onRegister;

  const LoginFooter({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextLink(text: 'Register', onTap: onRegister)
      ],
    );
  }
}