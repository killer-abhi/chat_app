import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/screens/chat_screen.dart';

class GlobalChatScreen extends StatelessWidget {
  const GlobalChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChatScreen(
      toUser: User(
          email: 'globalUser',
          imageUrl: 'globalUser',
          userId: 'globalUser',
          userName: 'globalUser'),
    );
  }
}
