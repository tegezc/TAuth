// file: test/data/repositories/auth_repository_impl_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/src/core/error/exceptions.dart';
import 'package:tauth/src/data/models/auth_user_model.dart';
import 'package:tauth/src/data/repositories/auth_repository_impl.dart';
import 'package:tauth/tauth.dart';
import '../../helpers/test_mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('loginWithEmail', () {
    const tEmail = 'test@email.com';
    const tPassword = 'password123';
    const tUserModel = AuthUserModel(uid: '123', email: tEmail);

    test('harus mengembalikan Right(AuthUser) jika login remote berhasil', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithEmail(any(), any()))
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.loginWithEmail(tEmail, tPassword);

      // Assert
      expect(result, equals(const Right(tUserModel)));
      verify(() => mockRemoteDataSource.loginWithEmail(tEmail, tPassword));
    });

    test('harus mengembalikan Left(AuthFailure) jika remote melempar ServerException', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithEmail(any(), any()))
          .thenThrow(ServerException('Password salah'));

      // Act
      final result = await repository.loginWithEmail(tEmail, tPassword);

      // Assert
      expect(result, equals(const Left(AuthFailure('Password salah'))));
    });
  });

  group('logout', () {
    test('harus membersihkan cache lokal dan memanggil remote logout', () async {
      // Arrange
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => Future.value());
      when(() => mockLocalDataSource.clearAllData()).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockLocalDataSource.clearAllData()).called(1);
    });
  });
}