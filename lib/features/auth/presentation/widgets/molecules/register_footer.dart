import 'package:flutter/material.dart';
import '../atoms/text_link.dart';

class RegisterFooter extends StatelessWidget {
  final VoidCallback onLogin;

  const RegisterFooter({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        TextLink(text: 'Login', onTap: onLogin)
      ],
    );
  }
}