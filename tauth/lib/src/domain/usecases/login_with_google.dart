// file: lib/src/domain/usecases/login_with_google.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

/// UseCase untuk mengeksekusi aksi Login via Google Sign-In.
/// Selalu gunakan class ini dari Presentation Layer, jangan panggil Repository secara langsung.
class LoginWithGoogleUseCase implements TAuthFutureUseCase<TAuthUser, TAuthNoParams> {
  final TAuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  @override
  Future<Either<TAuthFailure, TAuthUser>> call(TAuthNoParams params) async {
    return await repository.loginWithGoogle();
  }
}