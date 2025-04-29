import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/identity_repository.dart';
import '../../domain/entities/identity_entity.dart';
import '../models/identity_model.dart';
import '../datasources/identity_remote_data_source.dart';

@LazySingleton(as: IdentityRepository)
class IdentityRepositoryImpl implements IdentityRepository {
  final IdentityRemoteDataSource remoteDataSource;

  IdentityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, IdentityEntity>> getIdentity() async {
    try {
      final model = await remoteDataSource.fetchIdentity();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> updateIdentity({
    required String identityId,
    required String identityPhoto,
    required String address,
  }) async {
    try {
      final model = IdentityModel.fromJson({
        'identity_id': identityId,
        'identity_photo': identityPhoto,
        'address': address,
      });
      await remoteDataSource.updateIdentity(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
}
