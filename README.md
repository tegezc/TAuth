# TAuth

# TAuth (Headless Authentication Package)
TAuth adalah package otentikasi Flutter yang dibangun dengan prinsip Clean Architecture yang sangat ketat (Strict Clean Architecture). Package ini bersifat headless (tanpa antarmuka pengguna/UI) dan agnostik terhadap State Management, menjadikannya sangat fleksibel, mudah diuji (100% test coverage di layer bisnis), dan siap dipasang di aplikasi mana pun.

## Fitur Utama
- Headless Architecture: Tidak memuat Widget atau layar (Screen) apa pun. Murni mengurus logika Authentication.
- Agnostik State Management: Tidak bergantung pada BLoC, Riverpod, atau GetX di dalam package.
- Strict Clean Architecture: Pemisahan mutlak antara Domain (Bisnis) dan Data (Implementasi eksternal). Aplikasi utama dilarang keras mengakses Data Layer.
- Functional Error Handling: Menggunakan dartz (Either) untuk memastikan tidak ada exception yang tidak tertangani yang bocor ke aplikasi utama.
- Inversion of Control (IoC): Menggunakan pola Factory Module (TAuthModule) agar aplikasi utama bisa merakit repository tanpa mengetahui detail Data Layer.
- Support:
    - Firebase Auth (Email & Password)
    - Google Sign-In (Mendukung v7.2.0+ terbaru)
    - Flutter Secure Storage (Penyimpanan lokal terenkripsi)

## Instalasi
Karena ini adalah local package, tambahkan di pubspec.yaml pada aplikasi utama Anda (TExmp) menggunakan deklarasi path:
```yaml
dependencies:
  t_auth:
    path: ./path/to/t_auth
```
**Ketergantungan Eksternal (External Dependencies)**
Package ini mendefinisikan library berikut di pubspec.yaml-nya:

- dartz & equatable
- firebase_auth
- google_sign_in
- flutter_secure_storage
## Arsitektur & Aturan Ekspor

TAuth menyembunyikan semua implementasi teknis di dalam folder src/. Aplikasi utama hanya boleh mengimpor barrel file utama:
```dart
import 'package:t_auth/t_auth.dart';
```

### Cara Integrasi (Penggunaan di Aplikasi Utama)

1. Setup Dependency Injection (Contoh dengan injectable & get_it)
Di aplikasi utama Anda, buat sebuah module untuk membungkus dependencies eksternal dan memanggil factory dari TAuth.
```dart
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:t_auth/t_auth.dart';

@module
abstract class TAuthInjectableModule {
  
  // 1. Sediakan Bahan Mentah (Dikuasai oleh Aplikasi Utama)
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn.instance;

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  // 2. Rakit Repository melalui Factory TAuthModule
  @lazySingleton
  AuthRepository getAuthRepository(
    FirebaseAuth fbAuth,
    GoogleSignIn googleSignIn,
    FlutterSecureStorage storage,
  ) {
    return TAuthModule.createRepository(
      firebaseAuth: fbAuth,
      googleSignIn: googleSignIn,
      secureStorage: storage,
    );
  }

  // 3. Daftarkan UseCases
  @lazySingleton
  ObserveAuthStateUseCase getObserveUseCase(AuthRepository repo) =>
      TAuthModule.createObserveUseCase(repo);
      
  @lazySingleton
  LoginWithGoogleUseCase getLoginGoogleUseCase(AuthRepository repo) =>
      TAuthModule.createLoginGoogleUseCase(repo);
      
  @lazySingleton
  LogoutUseCase getLogoutUseCase(AuthRepository repo) =>
      TAuthModule.createLogoutUseCase(repo);
}
```

2. Menggunakan UseCases (Contoh dengan flutter_bloc)
UseCase mengembalikan Either<Failure, Type>. Gunakan .fold untuk menangani hasil sukses atau gagal secara fungsional.

    a. Reaktif Mendengarkan Status Auth (Stream)
    ```dart
    class AppSessionBloc extends Bloc<AppSessionEvent, AppSessionState> {
        final ObserveAuthStateUseCase _observeAuthState;
        late final StreamSubscription _subscription;

        AppSessionBloc(this._observeAuthState) : super(SessionInitial()) {
            // Dengarkan perubahan state (Login/Logout) secara real-time
            _subscription = _observeAuthState(NoParams()).listen((result) {
            result.fold(
                (failure) => add(SessionErrorEvent(failure.message)),
                (user) {
                if (user != null) {
                    add(SessionUserLoggedInEvent(user.uid));
                } else {
                    add(SessionUserLoggedOutEvent());
                }
                },
            );
        });
        }

        @override
        Future<void> close() {
            _subscription.cancel(); // Mencegah memory leak
            return super.close();
        }
    }
     ```
    b. Melakukan Aksi Login (Future)
    ```dart
    class LoginBloc extends Bloc<LoginEvent, LoginState> {
        final LoginWithGoogleUseCase _loginWithGoogle;

        LoginBloc(this._loginWithGoogle) : super(LoginInitial()) {
            on<LoginGooglePressed>((event, emit) async {
            emit(LoginLoading());
      
            final result = await _loginWithGoogle(NoParams());
      
            result.fold(
                (failure) => emit(LoginFailure(failure.message)),
                (user) => emit(LoginSuccess(user)), // Biarkan AppSessionBloc yang memindah halaman
            );
            });
        }
    }
    ```

## Pengujian (Testing)
Package ini mencakup Unit Test yang komprehensif menggunakan mocktail dan flutter_test.

Untuk menjalankan semua pengujian:
```dart
flutter test
```

Coverage meliputi:

- Semua UseCases memvalidasi kontrak Repository.
- Repository Implementation memetakan semua Exception menjadi Failure.
- Remote Data Source menangani interaksi Firebase dan konversi Google Sign-In (v7+) dengan penanganan error spesifik.