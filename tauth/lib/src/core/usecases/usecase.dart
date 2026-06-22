// lib/src/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

abstract class TAuthFutureUseCase<T, Params> {
  Future<Either<TAuthFailure, T>> call(Params params);
}

abstract class TAuthStreamUseCase<T, Params> {
  Stream<Either<TAuthFailure, T>> call(Params params);
}

class TAuthNoParams extends Equatable {
  @override
  List<Object?> get props => [];
}