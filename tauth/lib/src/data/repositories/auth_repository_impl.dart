// file: lib/src/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements TAuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Either<TAuthFailure, TAuthUser?>> get authStateChanges {
    return remoteDataSource.authStateChanges.map<Either<TAuthFailure, TAuthUser?>>((userModel) {
      // Karena AuthUserModel adalah extends dari AuthUser (Polymorphism),
      // kita bisa langsung mengirimnya ke Right()
      return Right(userModel);
    }).handleError((error) {
      // Mencegah aplikasi crash jika stream Firebase tiba-tiba error
      return Left(TAuthServerFailure('Gagal mendengarkan status otentikasi.'));
    });
  }

  @override
  Future<Either<TAuthFailure, TAuthUser>> loginWithEmail(String email, String password) async {
    try {
      final userModel = await remoteDataSource.loginWithEmail(email, password);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(TAuthServerFailure(e.message));
    } catch (e) {
      return Left(const TAuthServerFailure('Terjadi kesalahan sistem.'));
    }
  }

  @override
  Future<Either<TAuthFailure, TAuthUser>> loginWithGoogle() async {
    try {
      final userModel = await remoteDataSource.loginWithGoogle();
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(TAuthServerFailure(e.message));
    } catch (e) {
      return Left(const TAuthServerFailure('Terjadi kesalahan sistem.'));
    }
  }

  @override
  Future<Either<TAuthFailure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      // Pastikan membersihkan data cache lokal saat user logout
      await localDataSource.clearAllData();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(TAuthServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(TAuthCacheFailure(e.message));
    } catch (e) {
      return Left(const TAuthServerFailure('Terjadi kesalahan saat logout.'));
    }
  }
}