import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../../../core/errors/failures.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase signInUseCase;

  SignInCubit(this.signInUseCase) : super(SignInInitial());

  Future<void> signIn(String email, String password) async {
    emit(SignInLoading());

    final result = await signInUseCase(SignInParams(email: email, password: password));

    result.fold(
      (failure) => emit(SignInFailure(_mapFailureToMessage(failure))),
      (user) => emit(SignInSuccess(user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return 'Server error occurred';
    if (failure is CacheFailure) return 'Cache error occurred';
    return 'Unexpected error';
  }
}
