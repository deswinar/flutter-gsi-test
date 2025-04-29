// TODO: Build SignUpPage UI and logic
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keanggotaan/features/auth/presentation/widgets/organisms/sign_up_card.dart';

import '../widgets/templates/auth_template.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: SignUpCard(
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        onRegister: () {
          context.go('/sign-in');
        },
        onLogin: () {
          context.go('/sign-in');
        },
      ),
    );
  }
}
