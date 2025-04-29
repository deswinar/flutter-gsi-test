import 'package:equatable/equatable.dart';

class IdentityEntity extends Equatable {
  final String identityId;
  final String identityPhoto; // base64 string now
  final String address;

  IdentityEntity({
    required this.identityId,
    required this.identityPhoto,
    required this.address,
  });

  @override
  List<Object?> get props => [identityId, identityPhoto, address];
}
