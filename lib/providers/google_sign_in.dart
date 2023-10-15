import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;
  dynamic get currentUser => getUserDetails();
  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    dynamic loginDetails =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    if (loginDetails.additionalUserInfo.isNewUser) {
      final newUser = User(
          email: _user!.email,
          imageUrl: _user!.photoUrl.toString(),
          userId: _user!.id,
          userName: _user!.displayName.toString());

      final db = FirebaseFirestore.instance;
      return db.collection('users').doc(newUser.email).set(newUser.toMap());
    }
    notifyListeners();
  }

  Future<dynamic> getUserDetails() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.FirebaseAuth.instance.currentUser!.email)
        .get();

    return user;
  }
}
