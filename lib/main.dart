import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:lil_wardrobe/amplifyconfiguration.dart';
import 'package:lil_wardrobe/services/auth_service.dart';
import 'package:lil_wardrobe/ui/pages/login_page.dart';
import 'package:lil_wardrobe/ui/pages/signup_page.dart';
import 'package:lil_wardrobe/ui/pages/verification_page.dart';

import 'ui/widget/organisms/camera_flow.dart';

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

  /// Amplifyのインタスタンスを作成
  final _amplify = Amplify();

  @override
  void initState() {
    super.initState();

    /// 状態が初期化された時ログイン状態を送信
    _authService.showLogin();

    ///状態が初期化された時Amplifyを設定
    _configureAmplify();
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
                  /// Loginケース
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                      shouldShowSignUp: _authService.showSignUp,
                      didProvideCredentials: _authService.loginWithCredentials,
                    )),

                  /// SignUpケース
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
                      shouldShowLogin: _authService.showLogin,
                      didProvideCredentials: _authService.signUpWithCredentials,
                    )),

                  /// verificationケース
                  if (snapshot.data!.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        child: VerificationPage(
                            didProvideVerificationCode:
                                _authService.verifyCode)),

                  /// logOutケース
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        child: CameraFlow(shouldLogOut: _authService.logOut))
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
        ));
  }

  /// Amplifyを設定する関数
  void _configureAmplify() async {
    /// 認証プラグイン
    _amplify.addPlugin(authPlugins: [AmplifyAuthCognito()]);

    try {
      await _amplify.configure(amplifyconfig);
      print("configure Amplify");
    } catch (err) {
      print("could not configure Amplify");
    }
  }
}
