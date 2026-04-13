// lib/src/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  /// Stream reaktif untuk mendengarkan perubahan status login (Login/Logout)
  Stream<Either<Failure, AuthUser?>> get authStateChanges;

  /// Aksi untuk login menggunakan Email dan Password
  Future<Either<Failure, AuthUser>> loginWithEmail(String email, String password);

  Future<Either<Failure, AuthUser>> loginWithGoogle();

  /// Aksi untuk mengakhiri sesi
  Future<Either<Failure, void>> logout();
}