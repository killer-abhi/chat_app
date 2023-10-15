import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/screens/chat_screen.dart';
import 'package:global_chat/widgets/chat_messages.dart';

class CardData extends StatelessWidget {
  const CardData({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 24, top: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryContainer,
            offset: const Offset(8, 20),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(8, 20),
                  blurRadius: 24,
                ),
              ],
            ),
            child: ListTile(
              minLeadingWidth: 50,
              minVerticalPadding: 20,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              title: Text(
                user.userName,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: ChatMessages(
                    toUser: user,
                    fromUser: const User(
                        email: 'dk9554654249@gmail.com',
                        imageUrl: 'globalUser',
                        userId: '103774960897189757728',
                        userName: ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          textStyle: const TextStyle(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(toUser: user),
                              ),
                            );
                          },
                          icon: const Icon(Icons.messenger),
                          label: const Text('Chat'),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '2 days ago',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
