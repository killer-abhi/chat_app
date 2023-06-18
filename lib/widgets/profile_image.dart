import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({Key? key, required this.user}) : super(key: key);
  final dynamic user;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  var _imageUrl;
  void _fetch() {
    print('hi');
    print(widget.user);
    // final user = await FirebaseFirestore.instance.collection(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    print('fetchimage');
    _fetch();
    return const Text('Image Url');
  }
}
