#!/bin/bash
# Flutter Clean Architecture Base Structure Setup Script
# With Dartz, GetIt, Dio, and GoRouter Boilerplate

# Create necessary directories
mkdir -p lib/app/router
mkdir -p lib/app/injection
mkdir -p lib/app/theme

mkdir -p lib/core/constants
mkdir -p lib/core/components
mkdir -p lib/core/services
mkdir -p lib/core/utils
mkdir -p lib/core/errors
mkdir -p lib/core/network
mkdir -p lib/core/usecases
mkdir -p lib/core/widgets
mkdir -p lib/core/extensions

# ========== APP LAYER ==========
cat <<EOF > lib/app/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // Define your routes here
    // GoRoute(path: '/', builder: (context, state) => const HomePage()),
  ],
);
EOF

cat <<EOF > lib/app/injection/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt locator = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => await locator.init();
EOF

cat <<EOF > lib/app/injection/dio_module.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/network/dio_client.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dioClient() => createDioClient();
}
EOF

cat <<EOF > lib/app/theme/app_text_styles.dart
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle body = TextStyle(fontSize: 16);
}
EOF

cat <<EOF > lib/app/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_text_styles.dart';

final ThemeData appTheme = ThemeData(
  textTheme: const TextTheme(
    headlineMedium: AppTextStyles.heading,
    bodyMedium: AppTextStyles.body,
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);
EOF

# ========== CORE ==========
# Constants
cat <<EOF > lib/core/constants/app_strings.dart
class AppStrings {
  static const String appName = "Flutter App";
}
EOF

cat <<EOF > lib/core/constants/app_sizes.dart
class AppSizes {
  static const double padding = 16.0;
  static const double borderRadius = 8.0;
}
EOF

cat <<EOF > lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Colors.blue;
  static const secondary = Colors.green;
}
EOF

cat <<EOF > lib/core/constants/app_configs.dart
class AppConfigs {
  static const String baseUrl = "https://api.example.com/";
}
EOF

# Errors
cat <<EOF > lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
EOF

cat <<EOF > lib/core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
EOF

cat <<EOF > lib/core/errors/error_mapper.dart
import 'failures.dart';
import 'exceptions.dart';

Failure mapExceptionToFailure(Exception e) {
  if (e is ServerException) {
    return ServerFailure(e.message);
  } else if (e is CacheException) {
    return CacheFailure(e.message);
  } else {
    return ServerFailure('Unexpected error');
  }
}
EOF

# Network
cat <<EOF > lib/core/network/network_info.dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
EOF

cat <<EOF > lib/core/network/api_service.dart
import 'package:dio/dio.dart';

abstract class ApiService {
  final Dio dio;

  ApiService(this.dio);
}
EOF

cat <<EOF > lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../constants/app_strings.dart';

Dio createDioClient() {
  final options = BaseOptions(
    baseUrl: "https://api.example.com/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      "Accept": "application/json",
    },
  );

  final dio = Dio(options);

  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
  ));

  return dio;
}
EOF

# Usecases
cat <<EOF > lib/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // for @immutable
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

@immutable
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
EOF

# Extensions
cat <<EOF > lib/core/extensions/context_extension.dart
import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}
EOF

# ========== Additional boilerplate for injectable setup ==========
cat <<EOF > lib/app/injection/injection.config.dart
// GENERATED CODE - placeholder for injectable config. Run build_runner to generate.
EOF

# ========== Final Instructions ==========
echo ""
echo "✅ Base Flutter Clean Architecture structure created!"
echo "🚀 Next steps:"
echo "1. Add dependencies in pubspec.yaml:"
echo "   - get_it"
echo "   - injectable"
echo "   - injectable_generator (dev)"
echo "   - dartz"
echo "   - dio"
echo "   - go_router"
echo "2. Run build_runner:"
echo "   flutter pub run build_runner build --delete-conflicting-outputs"
