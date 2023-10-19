import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/models/message.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key, required this.toUser, required this.fromUser})
      : super(key: key);
  final User toUser;
  final User fromUser;

  @override
  Widget build(BuildContext context) {
    final isGlobalMessage = toUser.userId == 'globalUser';
    final collectionName = isGlobalMessage ? 'globalChat' : fromUser.userId;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName.toString())
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
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

        final loadedMessages = chatSnapshots.data!.docs
            .where((element) =>
                (element.get('toUser').toString() == toUser.userId) ||
                (element.get('fromUser').toString() == toUser.userId))
            .toList();
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.only(
            left: 13,
            right: 13,
            bottom: 40,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final message = Message(
                message: loadedMessages[index].get('message'),
                fromUser: loadedMessages[index].get('fromUser'),
                toUser: loadedMessages[index].get('toUser'),
                createdAt: loadedMessages[index].get('createdAt'),
                fromUserName: loadedMessages[index].get('fromUserName'),
                fromUserImageUrl:
                    loadedMessages[index].get('fromUserImageUrl'));

            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            // final currentMessageUserId = message.fromUser;
            final nextMessageUserEmail =
                nextChatMessage != null ? nextChatMessage['fromUser'] : null;

            final nextUserIsSame = message.fromUser == nextMessageUserEmail;

            if (nextUserIsSame) {
              return MessageBubble.next(
                isGlobalMessage: toUser.userId == 'globalUser',
                message: message.message,
                isMe: fromUser.userId == message.fromUser,
              );
            } else {
              return MessageBubble.first(
                isGlobalMessage: toUser.userId == 'globalUser',
                userImage: message.fromUserImageUrl,
                username: message.fromUserName,
                message: message.message,
                isMe: fromUser.userId == message.fromUser,
              );
            }
          },
        );
      },
    );
  }
}
