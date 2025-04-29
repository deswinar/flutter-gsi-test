import '../../domain/entities/identity_entity.dart';

class IdentityUiModel {
  final String identityId;
  final String identityPhoto; // base64 string
  final String address;

  IdentityUiModel({
    required this.identityId,
    required this.identityPhoto,
    required this.address,
  });

  factory IdentityUiModel.fromEntity(IdentityEntity entity) {
    return IdentityUiModel(
      identityId: entity.identityId,
      identityPhoto: entity.identityPhoto,
      address: entity.address,
    );
  }
}
