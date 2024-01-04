import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/providers/current_user.dart';
import 'package:global_chat/widgets/chat_messages.dart';
import 'package:global_chat/widgets/new_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.toUser}) : super(key: key);
  final User toUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _isOnline = '';

  void fetchOnlineStatus() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.toUser.email)
        .get()
        .then((doc) {
      if (doc.get('isOnline') == true) {
        setState(() {
          _isOnline = 'Online';
        });
      } else {
        setState(() {
          _isOnline = 'Offline';
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOnlineStatus();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).currUser;
    final User toUser = widget.toUser;

    // final isActive = toUser.isOnline;
    return Scaffold(
      appBar: toUser.email != 'globalUser'
          ? AppBar(
              leadingWidth: 20,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              title: ListTile(
                leading: Hero(
                  tag: toUser.email,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    foregroundImage: toUser.imageUrl != 'globalUser'
                        ? NetworkImage(toUser.imageUrl)
                        : null,
                    child: toUser.imageUrl == 'null'
                        ? Text(
                            toUser.userName[0],
                            style: const TextStyle(fontSize: 30),
                          )
                        : null,
                  ),
                ),
                title: Text(toUser.userName,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
                trailing: Text(_isOnline),
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              toUser: toUser,
              fromUser: currentUser,
            ),
          ),
          NewMessage(
            toUser: toUser,
            fromUser: currentUser,
          ),
        ],
      ),
    );
  }
}
