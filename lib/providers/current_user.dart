import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';

class CurrentUserProvider extends ChangeNotifier {
  User currUser = User(email: '', imageUrl: '', userId: '', userName: '');
  User get currentUser => currUser;
  void fetchUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((doc) {
      if (doc.data()!.isNotEmpty) {
        currUser.email = doc.get('email').toString();
        currUser.userName = doc.get('userName').toString();
        currUser.userId = doc.get('userId').toString();
        currUser.imageUrl = doc.get('imageUrl').toString();
      }
    });
  }
}
