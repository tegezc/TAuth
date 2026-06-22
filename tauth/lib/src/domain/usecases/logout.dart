import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/i_auth_repository.dart';

class LogoutUseCase implements TAuthFutureUseCase<void, TAuthNoParams> {
  final TAuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<TAuthFailure, void>> call(TAuthNoParams params) async {
    return await repository.logout();
  }
}