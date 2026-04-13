// file: test/domain/usecases/login_with_google_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/tauth.dart';
import '../../helpers/test_mocks.dart';

void main() {
  late LoginWithGoogleUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithGoogleUseCase(mockRepository);
  });

  const tAuthUser = AuthUser(uid: '123', email: 'google@email.com', displayName: 'Google User');

  test('harus memanggil fungsi loginWithGoogle dari repository', () async {
    // Arrange
    when(() => mockRepository.loginWithGoogle())
        .thenAnswer((_) async => const Right(tAuthUser));

    // Act
    // Karena menggunakan NoParams, kita lempar instance NoParams()
    final result = await useCase(NoParams());

    // Assert
    expect(result, const Right(tAuthUser));
    verify(() => mockRepository.loginWithGoogle()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}