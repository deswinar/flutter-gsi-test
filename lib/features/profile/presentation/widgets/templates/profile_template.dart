import 'package:flutter/material.dart';
import '../organisms/basic_profile_section.dart';
import '../organisms/identity_section.dart';

class ProfileTemplate extends StatelessWidget {
  const ProfileTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          BasicProfileSection(),
          SizedBox(height: 24),
          IdentitySection(),
        ],
      ),
    );
  }
}
