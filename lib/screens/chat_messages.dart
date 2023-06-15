import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key, required this.toUser, required this.fromUser})
      : super(key: key);
  final dynamic toUser;
  final dynamic fromUser;

  @override
  Widget build(BuildContext context) {
    final collectionName = toUser == 'globalUser'
        ? 'globalChat'
        : BigInt.parse(fromUser['userId']) + BigInt.parse(toUser['userId']);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName.toString())
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 13,
            right: 13,
            bottom: 40,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['fromUserId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['fromUserId'] : null;
            final nextUserIsSame = currentMessageUserId == nextMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  isGlobalMessage: toUser == 'globalUser',
                  message: chatMessage['message'],
                  isMe: fromUser['userId'] == currentMessageUserId);
            } else {
              return MessageBubble.first(
                isGlobalMessage: toUser == 'globalUser',
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['message'],
                isMe: fromUser['userId'] == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
