import 'package:go_router/go_router.dart';

import '../widgets/organisms/getting_started_content.dart';
import 'package:flutter/material.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GettingStartedContent(onGetStarted: () {
            // Navigate to Sign Up page
            context.go('/sign-up');
          }),
        ),
      ),
    );
  }
}
