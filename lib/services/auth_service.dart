import 'dart:async';

import 'package:lil_wardrobe/models/auth_credentials.dart';

///認証フローとして4つの段階がある
enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;
  AuthState({ required this.authFlowStatus });
}

class AuthService {
  final authStateController = StreamController<AuthState>();

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state =  AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  /// ユーザーをsession状態におく関数
  /// credentials [AuthCredentials]
  void loginWithCredentials(AuthCredentials credentials) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

  /// サインアップ時に状態をverificationにする関数
  /// signUp->Emailを検証する必要がある
  /// credentials [SignUpCredentials]
  void signUpWithCredentials(SignUpCredentials credentials) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
    authStateController.add(state);
  }

  /// 検証コードを処理し、状態をsessionにする関数
  /// verificationCode [String]
  void verifyCode(String verificationCode) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }
}