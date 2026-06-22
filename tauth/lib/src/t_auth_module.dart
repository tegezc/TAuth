// file: lib/src/t_auth_module.dart (Di dalam package TAuth)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/i_auth_repository.dart';
import 'domain/usecases/login_with_email.dart';
import 'domain/usecases/login_with_google.dart';
import 'domain/usecases/logout.dart';
import 'domain/usecases/observe_auth_state.dart';

/// Kelas Factory ini adalah SATU-SATUNYA tempat di mana
/// aplikasi luar bisa meminta instance dari TAuth.
class TAuthModule {

  /// Membuat instance AuthRepository yang sudah dirakit lengkap
  static TAuthRepository createRepository({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FlutterSecureStorage secureStorage,
  }) {
    // Rakit pekerja lokal
    final localDataSource = AuthLocalDataSourceImpl(secureStorage);

    // Rakit pekerja internet
    final remoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );

    // Kembalikan manajernya (Repository)
    return AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }

  // (Opsional) Factory untuk UseCases jika ingin lebih rapi
  static ObserveAuthStateUseCase createObserveUseCase(TAuthRepository repo) => ObserveAuthStateUseCase(repo);
  static LoginWithGoogleUseCase createLoginGoogleUseCase(TAuthRepository repo) => LoginWithGoogleUseCase(repo);
  static LoginWithEmailUseCase createLoginEmailUseCase(TAuthRepository repo) => LoginWithEmailUseCase(repo);
  static LogoutUseCase createLogoutUseCase(TAuthRepository repo) => LogoutUseCase(repo);
}