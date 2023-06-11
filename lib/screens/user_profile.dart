import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Profile Screen'),
    );
  }
}
