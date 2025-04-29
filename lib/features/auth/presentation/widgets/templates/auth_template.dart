import 'package:flutter/material.dart';

class AuthTemplate extends StatelessWidget {
  final Widget child;

  const AuthTemplate({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}
