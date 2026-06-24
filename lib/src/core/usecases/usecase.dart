// lib/src/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Kontrak dasar untuk UseCase yang mengembalikan [Future].
/// Memaksa pengembalian data dibungkus dalam [Either] untuk Functional Error Handling.
/// [Type] adalah tipe data jika sukses (Right), dan selalu mengembalikan [TAuthFailure] jika gagal (Left).
abstract class TAuthFutureUseCase<T, Params> {
  Future<Either<TAuthFailure, T>> call(Params params);
}

/// Kontrak dasar untuk UseCase yang mengembalikan [Stream].
/// Biasanya digunakan untuk mendengarkan perubahan state secara reaktif (real-time).
abstract class TAuthStreamUseCase<T, Params> {
  Stream<Either<TAuthFailure, T>> call(Params params);
}

/// Kelas parameter kosong yang dikirimkan ke UseCase ketika aksi tersebut 
/// tidak membutuhkan input apa pun dari pengguna (contoh: Logout atau Observe).
class TAuthNoParams extends Equatable {
  @override
  List<Object?> get props => [];
}