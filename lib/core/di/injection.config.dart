// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:trippath/core/di/injection.dart' as _i128;
import 'package:trippath/core/network/api_client.dart' as _i562;
import 'package:trippath/features/auth/data/datasources/auth_datasource.dart'
    as _i636;
import 'package:trippath/features/auth/data/datasources/auth_mock_datasource.dart'
    as _i201;
import 'package:trippath/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i506;
import 'package:trippath/features/auth/data/repositories/auth_repository_impl.dart'
    as _i711;
import 'package:trippath/features/auth/domain/repositories/auth_repository.dart'
    as _i99;
import 'package:trippath/features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i605;
import 'package:trippath/features/auth/domain/usecases/sign_in_with_google_usecase.dart'
    as _i617;
import 'package:trippath/features/auth/domain/usecases/sign_out_usecase.dart'
    as _i54;
import 'package:trippath/features/trip/data/datasources/trip_datasource.dart'
    as _i955;
import 'package:trippath/features/trip/data/datasources/trip_local_datasource.dart'
    as _i812;
import 'package:trippath/features/trip/data/repositories/trip_repository_impl.dart'
    as _i949;
import 'package:trippath/features/trip/domain/repositories/trip_repository.dart'
    as _i469;
import 'package:trippath/features/trip/domain/usecases/create_trip_usecase.dart'
    as _i981;
import 'package:trippath/features/trip/domain/usecases/get_trips_usecase.dart'
    as _i360;
import 'package:trippath/shared/services/auth/token_service.dart' as _i349;
import 'package:trippath/shared/services/storage/secure_storage_service.dart'
    as _i294;

const String _test = 'test';
const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i562.ApiClient>(() => _i562.ApiClient());
    gh.singleton<_i294.SecureStorageService>(
      () => _i294.SecureStorageService(),
    );
    gh.singleton<_i116.GoogleSignIn>(
      () => registerModule.googleSignIn,
      instanceName: 'googleSignIn',
    );
    gh.factory<_i955.TripDataSource>(() => _i812.TripLocalDataSource());
    gh.singleton<_i349.TokenService>(
      () => _i349.TokenService(
        gh<_i294.SecureStorageService>(),
        gh<_i562.ApiClient>(),
      ),
    );
    gh.factory<_i636.AuthDataSource>(
      () => _i201.AuthMockDataSource(
        gh<_i116.GoogleSignIn>(instanceName: 'googleSignIn'),
        gh<_i349.TokenService>(),
      ),
      registerFor: {_test},
    );
    gh.factory<_i469.TripRepository>(
      () => _i949.TripRepositoryImpl(gh<_i955.TripDataSource>()),
    );
    gh.factory<_i636.AuthDataSource>(
      () => _i506.AuthRemoteDataSource(
        gh<_i562.ApiClient>(),
        gh<_i116.GoogleSignIn>(instanceName: 'googleSignIn'),
        gh<_i349.TokenService>(),
      ),
      registerFor: {_dev},
    );
    gh.factory<_i99.AuthRepository>(
      () => _i711.AuthRepositoryImpl(
        gh<_i636.AuthDataSource>(),
        gh<_i349.TokenService>(),
      ),
    );
    gh.factory<_i981.CreateTripUseCase>(
      () => _i981.CreateTripUseCase(gh<_i469.TripRepository>()),
    );
    gh.factory<_i360.GetTripsUseCase>(
      () => _i360.GetTripsUseCase(gh<_i469.TripRepository>()),
    );
    gh.factory<_i617.SignInWithGoogleUseCase>(
      () => _i617.SignInWithGoogleUseCase(gh<_i99.AuthRepository>()),
    );
    gh.factory<_i605.GetCurrentUserUseCase>(
      () => _i605.GetCurrentUserUseCase(gh<_i99.AuthRepository>()),
    );
    gh.factory<_i54.SignOutUseCase>(
      () => _i54.SignOutUseCase(gh<_i99.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i128.RegisterModule {}
