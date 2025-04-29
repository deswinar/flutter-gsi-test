import '../../domain/entities/profile_entity.dart';

class ProfileUiModel {
  final String fullName;
  final String gender;
  final String status;

  ProfileUiModel({
    required this.fullName,
    required this.gender,
    required this.status,
  });

  factory ProfileUiModel.fromEntity(ProfileEntity entity) {
    return ProfileUiModel(
      fullName: entity.fullName,
      gender: entity.gender,
      status: entity.status,
    );
  }
}
