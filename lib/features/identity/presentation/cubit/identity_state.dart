part of 'identity_cubit.dart';

abstract class IdentityState {}

class IdentityInitial extends IdentityState {}
class IdentityLoading extends IdentityState {}
class IdentityLoaded extends IdentityState {
  final IdentityUiModel item;
  IdentityLoaded(this.item);
}
class IdentityError extends IdentityState {
  final String message;
  IdentityError(this.message);
}
