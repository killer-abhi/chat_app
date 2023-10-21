import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userDetails});
  final User userDetails;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  var _isUpdating = false;
  var _isEditing = true;
  var _imageWidget;
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

  @override
  void initState() {
    super.initState();
    _userNameController.text = widget.userDetails.userName;
    _imageWidget = NetworkImage(widget.userDetails.imageUrl);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  void _updateData() async {
    if (widget.userDetails.userName == _userNameController.text &&
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
          .child('${widget.userDetails.email}.jpg');
      await storageRef.putFile(_pickedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userDetails.email)
          .set({
        ...widget.userDetails.toMap(),
        'imageUrl': imageUrl,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userDetails.email)
          .set({
        ...widget.userDetails.toMap(),
        'userName': _userNameController.text,
      });
    }
    setState(() {
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = widget.userDetails;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundImage: _imageWidget,
              child: userDetails.imageUrl == 'null'
                  ? Text(
                      userDetails.userName[0],
                      style: const TextStyle(fontSize: 100),
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
              initialValue: userDetails.email,
              enabled: false,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.FirebaseAuth.instance.currentUser!.email)
                        .get()
                        .then((doc) {
                      if (doc.data()!.isNotEmpty) {
                        return FirebaseFirestore.instance
                            .collection('users')
                            .doc(doc.get('email').toString())
                            .update({'isOnline': false});
                      }
                    }).then((res) {
                      auth.FirebaseAuth.instance.signOut();
                    });
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
                  onPressed: _updateData,
                  icon: _isUpdating
                      ? const Icon(Icons.change_circle)
                      : const Icon(Icons.restart_alt_rounded),
                  label: Text(_isUpdating ? 'Updating ...' : 'Update Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
