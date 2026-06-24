// file: lib/src/t_auth_module.dart
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

/// Gerbang perakitan (Factory / Composition Root) untuk modul TAuth.
/// Kelas ini mengeksekusi Inversion of Control (IoC), memungkinkan aplikasi utama
/// merakit Data Layer tanpa perlu mengekspos kode internal implementasinya.
class TAuthModule {

  /// Merakit [TAuthRepository] dengan menyuntikkan dependensi eksternal (Firebase, Storage).
  /// Wajib dipanggil oleh Dependency Injection container di aplikasi utama (contoh: GetIt/Injectable).
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

  /// Membungkus [TAuthRepository] ke dalam [ObserveAuthStateUseCase].
  static ObserveAuthStateUseCase createObserveUseCase(TAuthRepository repo) => ObserveAuthStateUseCase(repo);
  
  /// Membungkus [TAuthRepository] ke dalam [LoginWithGoogleUseCase].
  static LoginWithGoogleUseCase createLoginGoogleUseCase(TAuthRepository repo) => LoginWithGoogleUseCase(repo);
  
  /// Membungkus [TAuthRepository] ke dalam [LoginWithEmailUseCase].
  static LoginWithEmailUseCase createLoginEmailUseCase(TAuthRepository repo) => LoginWithEmailUseCase(repo);
  
  /// Membungkus [TAuthRepository] ke dalam [LogoutUseCase].
  static LogoutUseCase createLogoutUseCase(TAuthRepository repo) => LogoutUseCase(repo);
}