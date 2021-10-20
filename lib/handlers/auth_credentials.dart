/// ログイン、サインアップに必要な最低限の基本情報に使用する
/// 抽象クラス
abstract class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({ required this.username, required this.password });
}

/// ログインの具体的実装
/// ユーザー名[String]とパスワード[String]のみを必要としている
class LoginCredentials extends AuthCredentials {
  LoginCredentials({ required String username, required String password})
    : super(username: username, password: password);
}

/// サインアップの具体的実装
/// ユーザー名[String]とパスワード[String]、Eメール[String]の情報が必要。
class SignUpCredentials extends AuthCredentials {
  final String email;

  SignUpCredentials({ required String username, required String password, required this.email })
    : super(username: username, password: password);
}