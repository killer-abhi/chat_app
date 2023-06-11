import 'package:flutter/material.dart';

class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({Key? key}) : super(key: key);

  @override
  State<RecentChatsScreen> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Recent Chats Screen'),
    );
  }
}
