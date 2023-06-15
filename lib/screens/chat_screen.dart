import 'package:flutter/material.dart';
import 'package:global_chat/providers/google_sign_in.dart';
import 'package:global_chat/screens/chat_messages.dart';
import 'package:global_chat/widgets/new_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.toUser}) : super(key: key);
  final dynamic toUser;
  // final dynamic fromUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _currentUser;

  void getDetails() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    dynamic userDetails = await provider.currentUser;
    setState(() {
      _currentUser = userDetails.data();
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic toUser = widget.toUser;
    return Scaffold(
      appBar: toUser != 'globalUser'
          ? AppBar(
              leadingWidth: 30,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              title: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  foregroundImage: toUser['image_url'] != null
                      ? NetworkImage(toUser['image_url'])
                      : null,
                  child: toUser['image_url'] == null
                      ? Text(
                          toUser['username'][0],
                          style: const TextStyle(fontSize: 30),
                        )
                      : null,
                ),
                title: Text(toUser['username']),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_call),
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          if (_currentUser != null)
            Expanded(
              child: ChatMessages(
                toUser: widget.toUser,
                fromUser: _currentUser,
              ),
            ),
          if (_currentUser != null)
            NewMessage(
              toUser: toUser,
              fromUser: _currentUser,
            ),
        ],
      ),
    );
  }
}
