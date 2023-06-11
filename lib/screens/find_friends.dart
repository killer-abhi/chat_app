import 'package:flutter/material.dart';

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({Key? key}) : super(key: key);

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Find Friends Screen'),
    );
  }
}
