import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/auth/login.dart';
import 'package:global_chat/navigation/navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((doc) {
        if (doc.data()!.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(doc.get('email').toString())
              .update({'isOnline': true});
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((doc) {
        if (doc.data()!.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(doc.get('email').toString())
              .update({'isOnline': false});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            return const NavigationScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
