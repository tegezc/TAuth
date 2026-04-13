import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/error/exceptions.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel?> get authStateChanges;
  Future<AuthUserModel> loginWithEmail(String email, String password);
  Future<AuthUserModel> loginWithGoogle();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  // Dependency Injected dari luar!
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Stream<AuthUserModel?> get authStateChanges {
    // Membaca stream asli Firebase, lalu dikonversi (map) menjadi Model kita
    return firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        return AuthUserModel.fromFirebaseUser(user);
      }
      return null;
    });
  }

  @override
  Future<AuthUserModel> loginWithEmail(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return AuthUserModel.fromFirebaseUser(credential.user!);
      } else {
        throw ServerException('User tidak ditemukan setelah login.');
      }
    } on firebase.FirebaseAuthException catch (e) {
      // Tangkap error spesifik Firebase, lempar sebagai ServerException internal
      throw ServerException(e.message ?? 'Gagal login dengan email.');
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga.');
    }
  }

  @override
  Future<AuthUserModel> loginWithGoogle() async {
    try {
      // 1. WAJIB di v7+: Inisialisasi dulu sebelum memanggil fungsi apa pun
      // (Bisa dipanggil berkali-kali, library akan mengabaikan jika sudah jalan)
      await googleSignIn.initialize();

      // 2. Munculkan popup Google (Gunakan authenticate, bukan signIn)
      final googleUser = await googleSignIn.authenticate();

      // 3. Dapatkan Id Token (Hanya untuk Authentication)
      final googleAuth = googleUser.authentication;

      // 4. Dapatkan Access Token (Untuk Authorization) - Ini cara baru di v7+
      final googleAuthorization = await googleUser.authorizationClient.authorizationForScopes([
        'email',
        'profile', // Scope default yang dibutuhkan Firebase
      ]);

      // 5. Masukkan token tersebut ke Firebase
      final firebase.AuthCredential credential = firebase.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuthorization?.accessToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return AuthUserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw ServerException('Gagal mendapatkan data user dari Google.');
      }
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Gagal otentikasi Firebase via Google.');
    } catch (e) {
      // Print error 'e' jika Anda ingin melihat log spesifik saat debugging
      throw ServerException('Terjadi kesalahan saat login Google.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Lakukan logout secara paralel untuk mempercepat proses
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw ServerException('Gagal melakukan logout.');
    }
  }
}