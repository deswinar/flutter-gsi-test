import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';

import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl(this.remoteDatasource, this.localDatasource);

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    try {
      final data = await remoteDatasource.signIn(email, password);
      print('SignIn data: $data');

      // Save token locally
      // final token = data['access_token'] as String?;
      // if (token != null) {
      //   await localDatasource.saveToken(token);
      // }

      final user = UserModel.fromJson(data);
      print('UserModel: $user');
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(String email, String password) async {
    try {
      await remoteDatasource.signUp(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDatasource.resetPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDatasource.signOut();
      await localDatasource.clearToken();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }

  /// Optional utility to access saved token
  Future<String?> getAccessToken() async {
    return await localDatasource.getToken();
  }
}
