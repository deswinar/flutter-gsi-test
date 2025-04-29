class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? accessToken;

  UserEntity({required this.id, required this.email, this.name, this.accessToken});
}
