import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required String fullName,
    required String gender,
    required String status,
  }) : super(
          fullName: fullName,
          gender: gender,
          status: status,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['full_name'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'gender': gender,
      'status': status,
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      fullName: entity.fullName,
      gender: entity.gender,
      status: entity.status,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      fullName: fullName,
      gender: gender,
      status: status,
    );
  }
}
