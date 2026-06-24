// lib/src/domain/usecases/logout.dart

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

/// UseCase untuk mengakhiri sesi pengguna (Logout).
/// Aksi ini akan membersihkan sesi di Firebase, Google Sign-In, dan menghapus cache lokal.
class LogoutUseCase implements TAuthFutureUseCase<void, TAuthNoParams> {
  final TAuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<TAuthFailure, void>> call(TAuthNoParams params) async {
    return await repository.logout();
  }
}