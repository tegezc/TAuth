// file: test/helpers/test_mocks.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauth/src/data/datasources/auth_local_data_source.dart';
import 'package:tauth/src/data/datasources/auth_remote_datasource.dart';
import 'package:tauth/src/domain/repositories/i_auth_repository.dart';

// Mocks untuk External Libraries
class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}
class MockFirebaseUser extends Mock implements firebase.User {}
class MockUserCredential extends Mock implements firebase.UserCredential {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

// Mocks untuk Internal Layers
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockAuthRepository extends Mock implements AuthRepository {}