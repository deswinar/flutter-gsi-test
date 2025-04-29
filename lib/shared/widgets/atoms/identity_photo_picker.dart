// lib/shared/widgets/atoms/identity_photo_picker.dart
import 'package:flutter/material.dart';

class IdentityPhotoPicker extends StatelessWidget {
  final String? photo;
  final VoidCallback onPick;

  const IdentityPhotoPicker({
    super.key,
    this.photo,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FDF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB7E4C7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.image, color: Color(0xFF40916C)),
          const SizedBox(width: 8),
          Text(photo ?? 'No Identity Photo selected'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFF40916C)),
            onPressed: onPick,
          ),
        ],
      ),
    );
  }
}
