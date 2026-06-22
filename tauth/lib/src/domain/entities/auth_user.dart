// lib/src/domain/entities/auth_user.dart
import 'package:equatable/equatable.dart';

class TAuthUser extends Equatable {
  final String uid;
  final String email;
  final String? displayName;

  const TAuthUser({
    required this.uid,
    required this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}