import 'dart:async';

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
}