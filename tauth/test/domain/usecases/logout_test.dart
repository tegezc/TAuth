// file: test/domain/usecases/logout_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/tauth.dart';
import '../../helpers/test_mocks.dart';

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  test('harus memanggil fungsi logout dari repository', () async {
    // Arrange
    when(() => mockRepository.logout())
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}