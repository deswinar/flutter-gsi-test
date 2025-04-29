import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/identity_entity.dart';

abstract class IdentityRepository {
  Future<Either<Failure, IdentityEntity>> getIdentity();
  Future<Either<Failure, void>> updateIdentity({
    required String identityId,
    required String identityPhoto,
    required String address,
  });
}
