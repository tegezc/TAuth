// file: test/data/datasources/auth_remote_data_source_test.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/src/core/error/exceptions.dart';
import 'package:tauth/src/data/datasources/auth_remote_datasource.dart';
import 'package:tauth/src/data/models/auth_user_model.dart';
import '../../helpers/test_mocks.dart';

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUserCredential mockUserCredential;
  late MockFirebaseUser mockFirebaseUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockFirebaseUser = MockFirebaseUser();

    // Setup behavior standar untuk mock user
    when(() => mockFirebaseUser.uid).thenReturn('123');
    when(() => mockFirebaseUser.email).thenReturn('test@email.com');
    when(() => mockFirebaseUser.displayName).thenReturn('User Test');

    dataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  // Karena FirebaseAuth.signInWithCredential membutuhkan class turunan asli dari AuthCredential,
  // kita buat fallback value palsu agar mocktail tidak error
  setUpAll(() {
    registerFallbackValue(firebase.AuthCredential(providerId: 'google.com', signInMethod: 'google.com'));
  });

  group('loginWithEmail', () {
    const tEmail = 'test@email.com';
    const tPassword = 'password123';

    test('harus mengembalikan AuthUserModel saat login berhasil', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockFirebaseUser);

      // Act
      final result = await dataSource.loginWithEmail(tEmail, tPassword);

      // Assert
      expect(result, isA<AuthUserModel>());
      expect(result.uid, '123');
    });

    test('harus melempar ServerException saat FirebaseAuthException terjadi', () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenThrow(firebase.FirebaseAuthException(code: 'user-not-found', message: 'User tidak ada'));

      // Act & Assert
      final call = dataSource.loginWithEmail;
      expect(() => call(tEmail, tPassword), throwsA(isA<ServerException>()));
    });
  });
}