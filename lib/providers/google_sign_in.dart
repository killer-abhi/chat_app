import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart' as account;
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
      final newUser = account.User(
          email: _user!.email,
          imageUrl: _user!.photoUrl.toString(),
          userId: _user!.id,
          userName: _user!.displayName.toString());
      // final user = <String, dynamic>{
      //   "userId": _user!.id,
      //   "username": _user!.displayName,
      //   "email": _user!.email,
      //   "image_url": _user!.photoUrl,
      // };

      final db = FirebaseFirestore.instance;
      return db.collection('users').doc(newUser.email).set(newUser.toMap());
    }
    notifyListeners();
  }

  Future<dynamic> getUserDetails() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    return user;
  }
}
