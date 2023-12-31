import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_chat/providers/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key? key, required this.isLogin}) : super(key: key);

  final bool isLogin;

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  var _isAuthenticating = false;
  void authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    await provider.googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticating
        ? Column(
            children: const [
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(),
            ],
          )
        : Card(
            margin: const EdgeInsets.all(20),
            child: TextButton.icon(
              onPressed: () {
                authenticate();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.purple,
              ),
              label: const Text('Continue with Google'),
            ),
          );
  }
}
