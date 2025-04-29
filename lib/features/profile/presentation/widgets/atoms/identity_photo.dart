import 'package:flutter/material.dart';

class IdentityPhoto extends StatelessWidget {
  final String imageUrl;

  const IdentityPhoto({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        alignment: Alignment.center,
        child: const Text(
          'No photo available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            alignment: Alignment.center,
            color: Colors.grey[100],
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            color: Colors.grey[200],
            child: const Text(
              'Failed to load photo',
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        },
      ),
    );
  }
}
