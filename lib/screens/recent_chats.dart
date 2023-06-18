import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/providers/google_sign_in.dart';
import 'package:global_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({Key? key}) : super(key: key);

  @override
  State<RecentChatsScreen> createState() => _RecentChatsScreenState();
}

class _RecentChatsScreenState extends State<RecentChatsScreen> {
  dynamic _currentUser;

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

  var collectionName;
  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      collectionName = _currentUser['email'];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _currentUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(collectionName)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, recentChatSnapshots) {
                if (recentChatSnapshots.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!recentChatSnapshots.hasData ||
                    recentChatSnapshots.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No messages found'),
                  );
                }
                if (recentChatSnapshots.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                final recentChats = recentChatSnapshots.data!.docs;

                return ListView.builder(
                  itemExtent: 90,
                  physics: const BouncingScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  dragStartBehavior: DragStartBehavior.down,
                  itemCount: recentChats.length,
                  itemBuilder: (context, index) {
                    final user = recentChats[index].data();
                    final isSent = _currentUser['userId'] == user['fromUserId'];
                    var toUserId;
                    if (isSent) {
                      toUserId = user['toUserId'];
                    } else {
                      toUserId = user['fromUserId'];
                    }
                    var message = user['message'].toString();
                    if (message.length > 20) {
                      message = '${message.substring(0, 19)} ...';
                    }
                    var messageTime = DateTime.fromMillisecondsSinceEpoch(
                        (user['createdAt'].seconds) * 1000);

                    final now = DateTime.now();
                    var timeDiff = now.difference(messageTime).inDays;
                    var timeText = '$timeDiff days ago';
                    if (timeDiff == 0) {
                      timeText = 'Today';
                    } else if (timeDiff == 1) {
                      timeText = 'Yesterday';
                    }
                    return Card(
                      child: ListTile(
                        key: ValueKey(index),
                        title: Text(
                          user['toUsername'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                        isThreeLine: true,
                        // tileColor: Theme.of(context).colorScheme.primaryContainer,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSent ? 'Sent -' : 'Received -',
                              style: const TextStyle(color: Colors.purple),
                            ),
                            Text(
                              message,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.surfaceTint,
                              ),
                            ),
                          ],
                        ),
                        horizontalTitleGap: 20,
                        minVerticalPadding: 20,
                        onTap: () {
                          final toUser = {
                            'image_url': user['toUserImage'],
                            'username': user['toUsername'],
                            'userId': toUserId,
                            'email': user['toUserEmail'],
                          };
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ChatScreen(
                              toUser: toUser,
                            ),
                          ));
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          foregroundImage: user['toUserImage'] == null
                              ? null
                              : NetworkImage(user['toUserImage']),
                          child: user['toUserImage'] == null
                              ? Text(
                                  user['toUsername'][0],
                                  style: const TextStyle(fontSize: 24),
                                )
                              : null,
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            timeText,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
