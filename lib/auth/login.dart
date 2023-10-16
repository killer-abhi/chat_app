import 'package:flutter/material.dart';
import 'package:global_chat/auth/email_auth.dart';
import 'package:global_chat/widgets/google_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLogin = true;
  var _isAuthenticating = false;
  var _isEmailSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isEmailSignUp || _isLogin)
                // Container(
                //   height: 150,
                //   width: 150,
                //   child: Image.asset('assets/images/logo.png'),
                // ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  width: 150,
                ),
              if (_isLogin || _isEmailSignUp)
                EmailAuthScreen(
                  isLogin: _isLogin,
                  isEmailSignUp: _isEmailSignUp,
                ),
              GoogleLogin(
                isLogin: _isLogin,
              ),
              if (!_isAuthenticating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLogin
                        ? 'Create a new account !'
                        : 'Already have an account?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _isEmailSignUp = true;
                        });
                      },
                      child: Text(_isLogin ? 'SignUp' : 'Login'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
