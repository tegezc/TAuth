// file: example/lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tauth/tauth.dart';

final locator = GetIt.instance;

void setupDependencies() {
  // 1. Eksternal
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => GoogleSignIn.instance);
  locator.registerLazySingleton(() => const FlutterSecureStorage());

  // 2. Rakit TAuth
  locator.registerLazySingleton<TAuthRepository>(() => TAuthModule.createRepository(
    firebaseAuth: locator(),
    googleSignIn: locator(),
    secureStorage: locator(),
  ));

  locator.registerLazySingleton(() => TAuthModule.createObserveUseCase(locator()));
  locator.registerLazySingleton(() => TAuthModule.createLoginGoogleUseCase(locator()));
  locator.registerLazySingleton(() => TAuthModule.createLogoutUseCase(locator()));
}