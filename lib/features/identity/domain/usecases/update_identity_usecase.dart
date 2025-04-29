import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/identity_repository.dart';
import '../entities/identity_entity.dart';

@injectable
class UpdateIdentityUseCase implements UseCase<void, UpdateIdentityParams> {
  final IdentityRepository repository;

  UpdateIdentityUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateIdentityParams params) async {
    return repository.updateIdentity(
      identityId: params.identityId,
      identityPhoto: params.identityPhoto,
      address: params.address,
    );
  }
}

class UpdateIdentityParams {
  final String identityId;
  final String identityPhoto;
  final String address;

  UpdateIdentityParams({
    required this.identityId,
    required this.identityPhoto,
    required this.address,
  });
}
