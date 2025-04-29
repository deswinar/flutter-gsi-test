import 'package:flutter/material.dart';
import 'package:keanggotaan/features/identity/presentation/models/identity_ui_model.dart';
import 'package:keanggotaan/features/profile/presentation/widgets/atoms/identity_photo.dart';
import 'identity_info_tile.dart';

class IdentityContent extends StatelessWidget {
  final IdentityUiModel identity;

  const IdentityContent({super.key, required this.identity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identity Info',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        IdentityInfoTile(label: 'Identity Number', value: identity.identityId),
        IdentityInfoTile(label: 'Address', value: identity.address),
        const SizedBox(height: 16),
        IdentityPhoto(imageUrl: identity.identityPhoto),
      ],
    );
  }
}
