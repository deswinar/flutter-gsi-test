import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/identity_entity.dart';
import '../repositories/identity_repository.dart';

@injectable
class GetIdentityUseCase implements UseCase<IdentityEntity, NoParams> {
  final IdentityRepository repository;

  GetIdentityUseCase(this.repository);

  @override
  Future<Either<Failure, IdentityEntity>> call(NoParams params) async {
    return repository.getIdentity();
  }
}
