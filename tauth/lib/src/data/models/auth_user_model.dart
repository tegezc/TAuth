// file: lib/src/data/models/auth_user_model.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.uid,
    required super.email,
    super.displayName,
  });

  // Fungsi sakti untuk mengubah objek kotor Firebase menjadi objek bersih bawaan kita
  factory AuthUserModel.fromFirebaseUser(firebase.User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email ?? '', // Antisipasi jika email null (meski jarang di Firebase Auth)
      displayName: user.displayName,
    );
  }
}