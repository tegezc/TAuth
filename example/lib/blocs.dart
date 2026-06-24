// file: example/lib/blocs.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tauth/tauth.dart';

// ==========================================
// 1. APP SESSION BLOC (Pendengar Stream)
// ==========================================
abstract class SessionState {}
class SessionLoading extends SessionState {}
class SessionUnauthenticated extends SessionState {}
class SessionAuthenticated extends SessionState {
  final TAuthUser user;
  SessionAuthenticated(this.user);
}

class AppSessionBloc extends Cubit<SessionState> {
  final ObserveAuthStateUseCase _observeAuth;
  late final StreamSubscription _sub;

  AppSessionBloc(this._observeAuth) : super(SessionLoading()) {
    _sub = _observeAuth(TAuthNoParams()).listen((result) {
      result.fold(
            (failure) => emit(SessionUnauthenticated()), // Jika error, anggap logout
            (user) {
          if (user != null) {
            emit(SessionAuthenticated(user));
          } else {
            emit(SessionUnauthenticated());
          }
        },
      );
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}

// ==========================================
// 2. LOGIN BLOC (Eksekutor Future)
// ==========================================
abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

class LoginBloc extends Cubit<LoginState> {
  final LoginWithGoogleUseCase _loginWithGoogle;
  final LogoutUseCase _logout;

  LoginBloc(this._loginWithGoogle, this._logout) : super(LoginInitial());

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    final result = await _loginWithGoogle(TAuthNoParams());
    result.fold(
          (failure) => emit(LoginFailure(failure.message)),
          (user) => emit(LoginInitial()), // Reset state karena AppSessionBloc yang ambil alih
    );
  }

  Future<void> logout() async {
    await _logout(TAuthNoParams());
  }
}