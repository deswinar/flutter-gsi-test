import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/hero-image.webp',
      height: 200,
      fit: BoxFit.contain,
    );
  }
}
