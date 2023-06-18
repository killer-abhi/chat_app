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
                Container(
                  height: 150,
                  width: 150,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              if (_isLogin || _isEmailSignUp)
                EmailAuthScreen(
                  isLogin: _isLogin,
                  isEmailSignUp: _isEmailSignUp,
                ),
              if (!_isLogin && !_isEmailSignUp)
                Card(
                  margin: const EdgeInsets.only(
                    top: 30,
                    left: 20,
                    right: 20,
                    bottom: 0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isEmailSignUp = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Email and Password'),
                  ),
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
                          if (_isEmailSignUp) {
                            _isEmailSignUp = !_isEmailSignUp;
                          }
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
