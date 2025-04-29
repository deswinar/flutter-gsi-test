import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String fullName;
  final String gender;
  final String status;

  ProfileEntity({
    required this.fullName,
    required this.gender,
    required this.status,
  });

  @override
  List<Object?> get props => [fullName, gender, status];
}
