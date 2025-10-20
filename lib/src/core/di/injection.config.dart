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
import 'package:gitconnect/src/core/network/api_client.dart' as _i567;
import 'package:gitconnect/src/data/remote/github_api_client.dart' as _i734;
import 'package:gitconnect/src/data/remote/openai_api_client.dart' as _i549;
import 'package:gitconnect/src/data/repository_impl/ai_repository_impl.dart'
    as _i535;
import 'package:gitconnect/src/data/repository_impl/repository_repository_impl.dart'
    as _i643;
import 'package:gitconnect/src/data/repository_impl/user_repository_impl.dart'
    as _i573;
import 'package:gitconnect/src/domain/repositories/ai_repository.dart' as _i702;
import 'package:gitconnect/src/domain/repositories/repository_repository.dart'
    as _i345;
import 'package:gitconnect/src/domain/repositories/user_repository.dart'
    as _i954;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.openaiDio(),
      instanceName: 'openai',
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.githubDio(),
      instanceName: 'github',
    );
    gh.lazySingleton<_i734.GitHubApiClient>(
      () => _i734.GitHubApiClient(gh<_i361.Dio>(instanceName: 'github')),
    );
    gh.lazySingleton<_i345.RepositoryRepository>(
      () => _i643.RepositoryRepositoryImpl(gh<_i734.GitHubApiClient>()),
    );
    gh.lazySingleton<_i954.UserRepository>(
      () => _i573.UserRepositoryImpl(gh<_i734.GitHubApiClient>()),
    );
    gh.lazySingleton<_i549.OpenAIApiClient>(
      () => _i549.OpenAIApiClient(gh<_i361.Dio>(instanceName: 'openai')),
    );
    gh.lazySingleton<_i702.AIRepository>(
      () => _i535.AIRepositoryImpl(gh<_i549.OpenAIApiClient>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}
