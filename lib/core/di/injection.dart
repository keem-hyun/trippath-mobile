import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies({String? environment}) => getIt.init(environment: environment);

@module
abstract class RegisterModule {
  @Named('googleSignIn')
  @singleton
  GoogleSignIn get googleSignIn => GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
}