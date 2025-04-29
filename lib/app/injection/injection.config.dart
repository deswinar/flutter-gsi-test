// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:keanggotaan/app/injection/dio_module.dart' as _i399;
import 'package:keanggotaan/core/network/identity_api_service.dart' as _i766;
import 'package:keanggotaan/core/network/network_info.dart' as _i33;
import 'package:keanggotaan/core/network/profile_api_service.dart' as _i637;
import 'package:keanggotaan/features/auth/data/datasources/auth_local_datasource.dart'
    as _i842;
import 'package:keanggotaan/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i51;
import 'package:keanggotaan/features/auth/data/repositories/auth_repository_impl.dart'
    as _i624;
import 'package:keanggotaan/features/auth/domain/repositories/auth_repository.dart'
    as _i55;
import 'package:keanggotaan/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i830;
import 'package:keanggotaan/features/auth/domain/usecases/sign_in_usecase.dart'
    as _i546;
import 'package:keanggotaan/features/auth/domain/usecases/sign_out_usecase.dart'
    as _i62;
import 'package:keanggotaan/features/auth/domain/usecases/sign_up_usecase.dart'
    as _i225;
import 'package:keanggotaan/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart'
    as _i646;
import 'package:keanggotaan/features/identity/data/datasources/identity_remote_data_source.dart'
    as _i554;
import 'package:keanggotaan/features/identity/data/repositories/identity_repository_impl.dart'
    as _i189;
import 'package:keanggotaan/features/identity/domain/repositories/identity_repository.dart'
    as _i603;
import 'package:keanggotaan/features/identity/domain/usecases/get_identity_usecase.dart'
    as _i881;
import 'package:keanggotaan/features/identity/domain/usecases/update_identity_usecase.dart'
    as _i475;
import 'package:keanggotaan/features/identity/presentation/cubit/identity_cubit.dart'
    as _i586;
import 'package:keanggotaan/features/profile/data/datasources/profile_remote_data_source.dart'
    as _i772;
import 'package:keanggotaan/features/profile/data/repositories/profile_repository_impl.dart'
    as _i914;
import 'package:keanggotaan/features/profile/domain/repositories/profile_repository.dart'
    as _i556;
import 'package:keanggotaan/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i628;
import 'package:keanggotaan/features/profile/domain/usecases/update_profile_usecase.dart'
    as _i164;
import 'package:keanggotaan/features/profile/presentation/cubit/profile_cubit.dart'
    as _i762;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.dioClient());
    gh.lazySingleton<_i842.AuthLocalDatasource>(
        () => _i842.AuthLocalDatasourceImpl());
    gh.lazySingleton<_i33.NetworkInfo>(() => _i33.NetworkInfoImpl());
    gh.lazySingleton<_i51.AuthRemoteDatasource>(
        () => _i51.AuthRemoteDatasourceImpl());
    gh.lazySingleton<_i766.IdentityApiService>(
        () => _i766.IdentityApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i637.ProfileApiService>(
        () => _i637.ProfileApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i554.IdentityRemoteDataSource>(
        () => _i554.IdentityRemoteDataSourceImpl(
              networkInfo: gh<_i33.NetworkInfo>(),
              apiService: gh<_i766.IdentityApiService>(),
            ));
    gh.lazySingleton<_i603.IdentityRepository>(() =>
        _i189.IdentityRepositoryImpl(gh<_i554.IdentityRemoteDataSource>()));
    gh.lazySingleton<_i772.ProfileRemoteDataSource>(
        () => _i772.ProfileRemoteDataSourceImpl(
              networkInfo: gh<_i33.NetworkInfo>(),
              apiService: gh<_i637.ProfileApiService>(),
            ));
    gh.lazySingleton<_i556.ProfileRepository>(
        () => _i914.ProfileRepositoryImpl(gh<_i772.ProfileRemoteDataSource>()));
    gh.lazySingleton<_i55.AuthRepository>(() => _i624.AuthRepositoryImpl(
          gh<_i51.AuthRemoteDatasource>(),
          gh<_i842.AuthLocalDatasource>(),
        ));
    gh.factory<_i830.ResetPasswordUseCase>(
        () => _i830.ResetPasswordUseCase(gh<_i55.AuthRepository>()));
    gh.factory<_i546.SignInUseCase>(
        () => _i546.SignInUseCase(gh<_i55.AuthRepository>()));
    gh.factory<_i62.SignOutUseCase>(
        () => _i62.SignOutUseCase(gh<_i55.AuthRepository>()));
    gh.factory<_i225.SignUpUseCase>(
        () => _i225.SignUpUseCase(gh<_i55.AuthRepository>()));
    gh.factory<_i881.GetIdentityUseCase>(
        () => _i881.GetIdentityUseCase(gh<_i603.IdentityRepository>()));
    gh.factory<_i475.UpdateIdentityUseCase>(
        () => _i475.UpdateIdentityUseCase(gh<_i603.IdentityRepository>()));
    gh.factory<_i628.GetProfileUseCase>(
        () => _i628.GetProfileUseCase(gh<_i556.ProfileRepository>()));
    gh.factory<_i164.UpdateProfileUseCase>(
        () => _i164.UpdateProfileUseCase(gh<_i556.ProfileRepository>()));
    gh.factory<_i646.SignInCubit>(
        () => _i646.SignInCubit(gh<_i546.SignInUseCase>()));
    gh.factory<_i762.ProfileCubit>(() => _i762.ProfileCubit(
          gh<_i628.GetProfileUseCase>(),
          gh<_i164.UpdateProfileUseCase>(),
        ));
    gh.factory<_i586.IdentityCubit>(() => _i586.IdentityCubit(
          gh<_i881.GetIdentityUseCase>(),
          gh<_i475.UpdateIdentityUseCase>(),
        ));
    return this;
  }
}

class _$DioModule extends _i399.DioModule {}
