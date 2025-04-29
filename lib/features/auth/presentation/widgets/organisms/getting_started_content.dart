import 'package:flutter/material.dart';
import '../../../../../shared/widgets/atoms/primary_button.dart';
import '../atoms/hero_image.dart';
import '../atoms/text_link.dart';

class GettingStartedContent extends StatelessWidget {
  final VoidCallback? onGetStarted;

  const GettingStartedContent({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rounded Hero Image
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const HeroImage(),
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            'Welcome to Shariacoin',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Bridging tradition with technology',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            'Start your journey now!',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Primary Button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Get Started',
              onPressed: onGetStarted ?? () {},
            ),
          ),

          const SizedBox(height: 16),

          // Optional link
          TextLink(
            text: 'Learn more about our mission',
            onTap: () {
              // TODO: Navigate to About Page
            },
          ),
        ],
      ),
    );
  }
}
