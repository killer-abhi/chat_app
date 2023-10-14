import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/providers/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  var _isUpdating = false;
  var _isEditing = true;
  var _imageWidget;
  var _enteredUsername = '';
  final _userNameController = TextEditingController();

  File? _pickedImage;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 300,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImage.path);
      _imageWidget = FileImage(_pickedImage!);
    });
  }

  dynamic _currentUser;
  void getDetails() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    dynamic userDetails = await provider.currentUser;
    if (mounted) {
      setState(() {
        _currentUser = userDetails.data();
        _enteredUsername = _currentUser['userName'];
        _userNameController.text = _enteredUsername;
      });
    }
    _imageWidget =
        _currentUser != null ? NetworkImage(_currentUser['imageUrl']) : null;
  }

  void _updateData() async {
    if (_currentUser['userName'] == _userNameController.text &&
        _pickedImage == null) {
      return;
    }
    setState(() {
      _isUpdating = true;
    });
    if (_pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${_currentUser['email']}.jpg');
      await storageRef.putFile(_pickedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser['email'])
          .set({
        ..._currentUser,
        'imageUrl': imageUrl,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser['email'])
          .set({
        ..._currentUser,
        'userName': _userNameController.text,
      });
    }
    setState(() {
      _isUpdating = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: _currentUser == null
          ? null
          : SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.purple,
                    foregroundImage: _imageWidget,
                    child: _currentUser['imageUrl'] == null
                        ? Text(
                            _currentUser['userName'][0],
                            style: const TextStyle(fontSize: 36),
                          )
                        : null,
                  ),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Change Photo'),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: _userNameController,
                      readOnly: _isEditing,
                      autofocus: !_isEditing,
                      onTapOutside: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          icon: const Icon(Icons.edit_rounded),
                        ),
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    initialValue: _currentUser['email'],
                    enabled: false,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                        onPressed: _updateData,
                        icon: _isUpdating
                            ? const Icon(Icons.change_circle)
                            : const Icon(Icons.restart_alt_rounded),
                        label: Text(
                            _isUpdating ? 'Updating ...' : 'Update Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
