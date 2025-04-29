import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/profile_repository.dart';
import '../entities/profile_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class UpdateProfileUseCase implements UseCase<void, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return repository.updateProfile(
      fullName: params.fullName,
      gender: params.gender,
    );
  }
}

class UpdateProfileParams {
  final String fullName;
  final String gender;

  UpdateProfileParams({
    required this.fullName,
    required this.gender,
  });
}
