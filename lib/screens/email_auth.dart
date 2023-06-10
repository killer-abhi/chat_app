import 'dart:io';
import 'package:flutter/material.dart';
import 'package:global_chat/widgets/user_image_picker.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen(
      {Key? key, required this.isLogin, required this.isEmailSignUp})
      : super(key: key);
  final bool isLogin;
  final bool isEmailSignUp;
  @override
  State<EmailAuthScreen> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuthScreen> {
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  File? _selectedImage;

  var _isAuthenticating = false;

  final _form = GlobalKey<FormState>();

  void submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = widget.isLogin;
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
              if (!isLogin)
                UserImagePicker(
                  onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                ),
              if (!isLogin)
                TextFormField(
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
                  child: Text(isLogin ? 'Login' : 'Create Account'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
