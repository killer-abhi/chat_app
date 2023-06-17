import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/providers/add_new_user.dart';
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

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    dynamic loginDetails =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (loginDetails.additionalUserInfo.isNewUser) {
      final user = <String, dynamic>{
        "userId": _user!.id,
        "username": _user!.displayName,
        "email": _user!.email,
        "image_url": _user!.photoUrl,
      };

      final db = FirebaseFirestore.instance;
      db.collection('users').doc(_user!.email).set(user);
    }
    notifyListeners();
  }

  dynamic getUserDetails() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    return user;
  }
}
