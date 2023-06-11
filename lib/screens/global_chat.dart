import 'package:flutter/material.dart';

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({Key? key}) : super(key: key);

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Global Chat Screen'),
    );
  }
}
