// lib/src/domain/usecases/login_with_email.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/i_auth_repository.dart';

class LoginWithEmailUseCase implements TAuthFutureUseCase<TAuthUser, LoginParams> {
  final TAuthRepository repository;

  LoginWithEmailUseCase(this.repository);

  @override
  Future<Either<TAuthFailure, TAuthUser>> call(LoginParams params) async {
    return await repository.loginWithEmail(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}