import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({
    super.key,
    required this.isLogin,
    required this.isEmailSignUp,
  });
  final bool isLogin;
  final bool isEmailSignUp;

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  var _enteredEmail = '';

  var _enteredUsername = '';

  var _enteredPassword = '';

  File? _selectedImage;

  var _isAuthenticating = false;

  final _form = GlobalKey<FormState>();

  void submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || !widget.isLogin && _selectedImage == null) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (widget.isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        var rdm = Random();
        var newUserId = '100000000000000' + rdm.nextInt(999999).toString();
        final user = <String, dynamic>{
          "userId": newUserId,
          "username": _enteredUsername,
          "email": _enteredEmail,
          "image_url": imageUrl,
        };

        final db = FirebaseFirestore.instance;
        db.collection('users').doc(_enteredEmail).set(user);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
          bottom: 30,
        ),
        child: Form(
          key: _form,
          child: Column(
            children: [
              if (!widget.isLogin)
                UserImagePicker(
                  onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                ),
              if (!widget.isLogin)
                TextFormField(
                  onTapOutside: (_) {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); //remove focus
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length < 4) {
                      return 'Username should be atleast 4 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredUsername = value!;
                  },
                ),
              TextFormField(
                onTapOutside: (_) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); //remove focus
                },
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter a valid Email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredEmail = value!;
                },
              ),
              TextFormField(
                onTapOutside: (_) {
                  FocusScope.of(context)
                      .requestFocus(FocusNode()); //remove focus
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 6) {
                    return 'Password should be atleast 6 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPassword = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              if (_isAuthenticating) const CircularProgressIndicator(),
              if (!_isAuthenticating)
                ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Text(widget.isLogin ? 'Login' : 'Create Account'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
