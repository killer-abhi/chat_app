import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/providers/add_new_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
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
      addNewUser(newUser);
    }
    notifyListeners();
  }
}
