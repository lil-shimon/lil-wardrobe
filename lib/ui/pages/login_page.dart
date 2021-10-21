import 'package:flutter/material.dart';
import 'package:lil_wardrobe/models/auth_credentials.dart';

class LoginPage extends StatefulWidget {

  final VoidCallback shouldShowSignUp;

  final ValueChanged<LoginCredentials> didProvideCredentials;

  LoginPage({  Key? key, required this.shouldShowSignUp, required this.didProvideCredentials });

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /// TextEditingControllerで状態を追跡
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 40),
        child: Stack(children: [
          _loginForm(),
          Container(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              onPressed: widget.shouldShowSignUp,
              child: Text('sign up'),),
            )
        ],)
      )
    );
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration:
              InputDecoration(icon: Icon(Icons.mail), labelText: 'Username'),
        ),

        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),

        // Login Button
        FlatButton(
            onPressed: _login,
            child: Text('Login'),
            color: Theme.of(context).accentColor)
      ],
    );
  }

  /// ログイン関数
  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('password: $password');

    /// 認証情報
    final credentials = LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
  }
}