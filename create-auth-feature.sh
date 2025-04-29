#!/bin/bash

# ========== Interactive Prompts ==========
read -p "Include Google Sign-In? (y/n): " INCLUDE_GOOGLE
read -p "Include Other Social Sign-Ins? (y/n): " INCLUDE_OTHER_SOCIAL

FEATURE_NAME="auth"
BASE_PATH="lib/features/$FEATURE_NAME"

# ========== Create Directory Structure ==========
mkdir -p "$BASE_PATH/data/datasources"
mkdir -p "$BASE_PATH/data/models"
mkdir -p "$BASE_PATH/data/repositories"
mkdir -p "$BASE_PATH/domain/entities"
mkdir -p "$BASE_PATH/domain/repositories"
mkdir -p "$BASE_PATH/domain/usecases"
mkdir -p "$BASE_PATH/presentation/pages"
mkdir -p "$BASE_PATH/presentation/widgets"

# ========== Domain Layer ==========
cat <<EOF > "$BASE_PATH/domain/entities/user_entity.dart"
class UserEntity {
  final String id;
  final String email;
  final String? name;

  UserEntity({required this.id, required this.email, this.name});
}
EOF

cat <<EOF > "$BASE_PATH/domain/repositories/auth_repository.dart"
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, void>> signUp(String email, String password);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> signOut();
}
EOF

cat <<EOF > "$BASE_PATH/domain/usecases/sign_in_usecase.dart"
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    return repository.signIn(params.email, params.password);
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
EOF

cat <<EOF > "$BASE_PATH/domain/usecases/sign_up_usecase.dart"
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class SignUpUseCase implements UseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignUpParams params) {
    return repository.signUp(params.email, params.password);
  }
}

class SignUpParams {
  final String email;
  final String password;

  SignUpParams({
    required this.email,
    required this.password,
  });
}
EOF

cat <<EOF > "$BASE_PATH/domain/usecases/sign_out_usecase.dart"
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
@injectable
class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
class NoParams {}
EOF

cat <<EOF > "$BASE_PATH/domain/usecases/reset_password_usecase.dart"
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) {
    return repository.resetPassword(params.email);
  }
}

class ResetPasswordParams {
  final String email;

  ResetPasswordParams({required this.email});
}
EOF

# ========== Data Layer ==========
cat <<EOF > "$BASE_PATH/data/models/user_model.dart"
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
  };
}
EOF

cat <<EOF > "$BASE_PATH/data/datasources/auth_remote_datasource.dart"
// TODO: Implement with Firebase/Auth0/your backend
abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // Stub
    return {
      'id': '123',
      'email': email,
      'name': 'John Doe',
    };
  }
  @override
  Future<void> signUp(String email, String password) async {
    // Stub

  }
  @override
  Future<void> resetPassword(String email) async {
    // Stub

  }
  @override
  Future<void> signOut() async {
    // Stub

  }
}
EOF

cat <<EOF > "$BASE_PATH/data/repositories/auth_repository_impl.dart"
import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
    try {
      final data = await remoteDatasource.signIn(email, password);
      final user = UserModel.fromJson(data);
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
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('An unknown error occurred'));
    }
  }
}
EOF

# ========== Optional Social Sign-In ==========
if [[ "$INCLUDE_GOOGLE" == "y" ]]; then
  cat <<EOF > "$BASE_PATH/data/datasources/google_auth_service.dart"
// TODO: Implement Google Sign-In using google_sign_in package
class GoogleAuthService {
  Future<void> signInWithGoogle() async {
    // Stub
  }
}
EOF
fi

if [[ "$INCLUDE_OTHER_SOCIAL" == "y" ]]; then
  cat <<EOF > "$BASE_PATH/data/datasources/social_auth_service.dart"
// TODO: Implement other providers (Facebook, Apple, etc.)
class SocialAuthService {
  Future<void> signInWithFacebook() async {
    // Stub
  }

  Future<void> signInWithApple() async {
    // Stub
  }
}
EOF
fi

# ========== Presentation TODO Pages ==========
cat <<EOF > "$BASE_PATH/presentation/pages/sign_in_page.dart"
// TODO: Build SignInPage UI and logic
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Sign In Page")),
    );
  }
}
EOF

cat <<EOF > "$BASE_PATH/presentation/pages/sign_up_page.dart"
// TODO: Build SignUpPage UI and logic
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Sign Up Page")),
    );
  }
}
EOF

cat <<EOF > "$BASE_PATH/presentation/pages/forgot_password_page.dart"
// TODO: Build ForgotPasswordPage UI and logic
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Forgot Password Page")),
    );
  }
}
EOF

echo "✅ Auth feature boilerplate generated at $BASE_PATH"
