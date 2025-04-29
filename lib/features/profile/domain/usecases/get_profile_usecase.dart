import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:keanggotaan/core/usecases/usecase.dart';
import 'package:keanggotaan/features/profile/domain/entities/profile_entity.dart';
import 'package:keanggotaan/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/errors/failures.dart';

@injectable
class GetProfileUseCase implements UseCase<ProfileEntity, NoParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
    return repository.getProfile();
  }
}