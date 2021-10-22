import 'package:flutter/material.dart';
import 'package:lil_wardrobe/services/auth_service.dart';
import 'package:lil_wardrobe/ui/pages/login_page.dart';
import 'package:lil_wardrobe/ui/pages/signup_page.dart';
import 'package:lil_wardrobe/ui/pages/verification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  /// AuthServiceのインスタンスを作成
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    /// 状態が初期化された時ログイン状態を送信
    _authService.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: StreamBuilder<AuthState>(
        /// authStateControllerからAuthStateストリームにアクセス
        stream: _authService.authStateController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Navigator(
              pages: [
                if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                  MaterialPage(child: LoginPage(
                    shouldShowSignUp: _authService.showSignUp,
                    didProvideCredentials: _authService.loginWithCredentials,
                  )),
                if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                  MaterialPage(child: SignUpPage(
                    shouldShowLogin: _authService.showLogin,
                    didProvideCredentials: _authService.signUpWithCredentials,
                  )),
                if (snapshot.data!.authFlowStatus == AuthFlowStatus.verification)
                  MaterialPage(
                    child: VerificationPage(didProvideVerificationCode: _authService.verifyCode)
                  ),
              ],
              onPopPage: (route, result) => route.didPop(result),
            );
          } else {
            /// streamにデータがない場合circularを表示
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}