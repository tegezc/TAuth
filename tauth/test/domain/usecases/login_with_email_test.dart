// file: test/domain/usecases/login_with_email_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/tauth.dart';
import '../../helpers/test_mocks.dart';

void main() {
  late LoginWithEmailUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithEmailUseCase(mockRepository);
  });

  const tEmail = 'test@email.com';
  const tPassword = 'password123';
  const tAuthUser = TAuthUser(uid: '123', email: tEmail);

  test('harus memanggil fungsi loginWithEmail dari repository', () async {
    // Arrange
    when(() => mockRepository.loginWithEmail(any(), any()))
        .thenAnswer((_) async => const Right(tAuthUser));

    // Act
    final result = await useCase(const LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result, const Right(tAuthUser));
    verify(() => mockRepository.loginWithEmail(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}