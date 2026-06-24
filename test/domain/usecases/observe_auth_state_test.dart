// file: test/domain/usecases/observe_auth_state_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/tauth.dart';
import '../../helpers/test_mocks.dart';

void main() {
  late ObserveAuthStateUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ObserveAuthStateUseCase(mockRepository);
  });

  const tAuthUser = TAuthUser(uid: '123', email: 'stream@email.com');

  test('harus mengembalikan Stream dari repository authStateChanges', () {
    // Arrange
    // Kita buat dummy stream yang memancarkan 1 event user
    final Stream<Either<TAuthFailure, TAuthUser?>> tStream = Stream.value(const Right(tAuthUser));

    when(() => mockRepository.authStateChanges).thenAnswer((_) => tStream);

    // Act
    final result = useCase(TAuthNoParams());

    // Assert
    expect(result, equals(tStream));
    verify(() => mockRepository.authStateChanges).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}