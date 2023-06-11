import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/login.dart';
import 'package:global_chat/screens/navigation_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String? hello;
    // hello!.length;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          } else if (snapshot.hasData) {
            return const UserScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
