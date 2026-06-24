// lib/src/core/error/failures.dart
import 'package:equatable/equatable.dart';

/// Kelas dasar (Base Class) untuk semua jenis error/kegagalan di package TAuth.
/// Menggunakan prefiks `TAuth` agar terhindar dari tabrakan nama (namespace collision)
/// dengan package lain yang mungkin juga memiliki kelas `Failure`.
abstract class TAuthFailure extends Equatable {
  /// Pesan error yang ramah pengguna (user-friendly) untuk ditampilkan ke UI.
  final String message;

  const TAuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Merepresentasikan kegagalan yang berasal dari layanan remote (seperti Firebase atau Google Sign-In).
class TAuthServerFailure extends TAuthFailure {
  const TAuthServerFailure(super.message);
}

/// Merepresentasikan kegagalan yang berasal dari penyimpanan lokal (seperti Secure Storage).
class TAuthCacheFailure extends TAuthFailure {
  const TAuthCacheFailure(super.message);
}