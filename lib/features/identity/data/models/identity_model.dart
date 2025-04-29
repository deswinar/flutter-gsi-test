import '../../domain/entities/identity_entity.dart';

class IdentityModel extends IdentityEntity {
  IdentityModel({
    required String identityId,
    required String identityPhoto,
    required String address,
  }) : super(
          identityId: identityId,
          identityPhoto: identityPhoto,
          address: address,
        );

  factory IdentityModel.fromJson(Map<String, dynamic> json) {
    return IdentityModel(
      identityId: json['identity_id'] as String,
      identityPhoto: json['identity_photo'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identity_id': identityId,
      'identity_photo': identityPhoto,
      'address': address,
    };
  }

  factory IdentityModel.fromEntity(IdentityEntity entity) {
    return IdentityModel(
      identityId: entity.identityId,
      identityPhoto: entity.identityPhoto,
      address: entity.address,
    );
  }

  IdentityEntity toEntity() {
    return IdentityEntity(
      identityId: identityId,
      identityPhoto: identityPhoto,
      address: address,
    );
  }
}
