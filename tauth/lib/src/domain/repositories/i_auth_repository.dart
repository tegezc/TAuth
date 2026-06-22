// lib/src/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_user.dart';

abstract class TAuthRepository {
  /// Stream reaktif untuk mendengarkan perubahan status login (Login/Logout)
  Stream<Either<TAuthFailure, TAuthUser?>> get authStateChanges;

  /// Aksi untuk login menggunakan Email dan Password
  Future<Either<TAuthFailure, TAuthUser>> loginWithEmail(String email, String password);

  Future<Either<TAuthFailure, TAuthUser>> loginWithGoogle();

  /// Aksi untuk mengakhiri sesi
  Future<Either<TAuthFailure, void>> logout();
}