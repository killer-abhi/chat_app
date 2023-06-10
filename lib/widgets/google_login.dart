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
  Widget content = const CircularProgressIndicator();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: TextButton.icon(
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogin();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.google,
          color: Colors.red,
        ),
        label:
            Text(widget.isLogin ? 'SignIn with Google' : 'SignUp with Google'),
      ),
    );
  }
}
