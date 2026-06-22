// lib/src/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class TAuthFailure extends Equatable {
  final String message;

  const TAuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class TAuthServerFailure extends TAuthFailure {
  const TAuthServerFailure(super.message);
}

class TAuthCacheFailure extends TAuthFailure {
  const TAuthCacheFailure(super.message);
}