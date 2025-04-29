part of 'sign_in_cubit.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final UserEntity user;

  const SignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInFailure extends SignInState {
  final String message;

  const SignInFailure(this.message);

  @override
  List<Object?> get props => [message];
}
