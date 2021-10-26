import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:lil_wardrobe/models/auth_credentials.dart';

///認証フローとして4つの段階がある
enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;
  AuthState({required this.authFlowStatus});
}

class AuthService {
  final authStateController = StreamController<AuthState>();

  /// AuthCredentialsプロパティ
  /// サインアッププロセス中、メモリにsignUpCredentialsを保持する
  late AuthCredentials _credentials;

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
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
  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      /// サインアップにユーザーのメールアドレスを渡すため作成
      final userAttributes = {'email': credentials.email};

      /// Cognitoにサインアップするためにユーザー情報を渡す
      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      /// 正常だった場合メールアドレスの認証
      /// プロセスが終わっていた場合はログインにする
      if (result.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        this._credentials = credentials;
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } on AuthError catch (authError) {
      print("サインアップに失敗しました。 >>> ${authError.cause}");
    }
  }

  /// 検証コードを処理し、状態をsessionにする関数
  /// verificationCode [String]
  void verifyCode(String verificationCode) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

  /// ログアウト関数
  void logOut() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }
}
