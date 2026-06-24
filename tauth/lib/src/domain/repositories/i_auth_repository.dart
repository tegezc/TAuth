// lib/src/domain/repositories/i_auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_user.dart';

/// Kontrak utama untuk fungsionalitas Otentikasi.
/// Semua implementasi (Firebase, dll) harus mematuhi interface ini.
abstract class TAuthRepository {
  /// Mendengarkan perubahan status login pengguna secara reaktif.
  /// Mengembalikan [TAuthUser] jika sedang login, atau null jika tidak ada sesi.
  Stream<Either<TAuthFailure, TAuthUser?>> get authStateChanges;


  Future<Either<TAuthFailure, TAuthUser>> loginWithEmail(String email, String password);

  /// Melakukan proses otentikasi menggunakan layanan Google Sign-In.
  /// Mengembalikan [TAuthFailure] jika proses dibatalkan atau gagal.
  Future<Either<TAuthFailure, TAuthUser>> loginWithGoogle();

  /// Mengakhiri sesi pengguna saat ini dan membersihkan cache lokal.
  Future<Either<TAuthFailure, void>> logout();
}