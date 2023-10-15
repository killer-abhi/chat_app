import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/widgets/chat_messages.dart';
import 'package:global_chat/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.toUser}) : super(key: key);
  final User toUser;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<DocumentSnapshot> getCurrentUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.FirebaseAuth.instance.currentUser!.email)
        .get();
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    final User toUser = widget.toUser;
    return FutureBuilder<DocumentSnapshot>(
        future: getCurrentUser(),
        builder: (BuildContext context, docSnapshot) {
          if (docSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final fromUser = User(
              email: docSnapshot.data!.get('email'),
              imageUrl: docSnapshot.data!.get('imageUrl'),
              userId: docSnapshot.data!.get('userId'),
              userName: docSnapshot.data!.get('userName'),
            );
            return Scaffold(
              appBar: toUser.email != 'globalUser'
                  ? AppBar(
                      leadingWidth: 30,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      title: ListTile(
                        leading: Hero(
                          tag: toUser.email,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            foregroundImage: toUser.imageUrl != 'globalUser'
                                ? NetworkImage(toUser.imageUrl)
                                : null,
                            child: toUser.imageUrl == 'globalUser'
                                ? Text(
                                    toUser.userName[0],
                                    style: const TextStyle(fontSize: 30),
                                  )
                                : null,
                          ),
                        ),
                        title: Text(toUser.userName),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_call),
                        ),
                      ),
                    )
                  : null,
              body: Column(
                children: [
                  Expanded(
                    child: ChatMessages(
                      toUser: toUser,
                      fromUser: fromUser,
                    ),
                  ),
                  NewMessage(
                    toUser: toUser,
                    fromUser: fromUser,
                  ),
                ],
              ),
            );
          }
        });
  }
}
