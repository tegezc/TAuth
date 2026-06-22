// lib/src/domain/usecases/observe_auth_state.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class ObserveAuthStateUseCase implements TAuthStreamUseCase<TAuthUser?, TAuthNoParams> {
  final TAuthRepository repository;

  ObserveAuthStateUseCase(this.repository);

  @override
  Stream<Either<TAuthFailure, TAuthUser?>> call(TAuthNoParams params) {
    return repository.authStateChanges;
  }
}