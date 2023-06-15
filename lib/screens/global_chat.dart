import 'package:flutter/material.dart';
import 'package:global_chat/screens/chat_screen.dart';

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({Key? key}) : super(key: key);

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const ChatScreen(
      toUser: 'globalUser',
    );
  }
}
