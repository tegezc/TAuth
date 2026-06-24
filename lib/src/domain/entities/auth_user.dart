// lib/src/domain/entities/auth_user.dart
import 'package:equatable/equatable.dart';

/// Entitas murni yang merepresentasikan pengguna yang sedang login.
/// Kelas ini sama sekali tidak memiliki ketergantungan pada Firebase User.
/// Jika Anda butuh menambahkan data pengguna (seperti role atau foto), tambahkan di sini.
class TAuthUser extends Equatable {
  /// ID unik pengguna yang dihasilkan oleh sistem otentikasi (Remote).
  final String uid;

  /// Alamat email pengguna.
  final String email;

  /// Nama tampilan pengguna (opsional).
  final String? displayName;

  const TAuthUser({
    required this.uid,
    required this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}