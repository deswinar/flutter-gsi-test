
part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final ProfileUiModel item;
  ProfileLoaded(this.item);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
