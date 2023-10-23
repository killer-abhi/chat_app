import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:global_chat/bottomSheet/online_users.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/providers/current_user.dart';
import 'package:global_chat/recentchats/card_data.dart';
import 'package:provider/provider.dart';

class SlidingCardsView extends StatefulWidget {
  const SlidingCardsView({super.key});

  @override
  State<SlidingCardsView> createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).currUser;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(auth.FirebaseAuth.instance.currentUser!.email!)
              .orderBy('updatedAt', descending: true)
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
              return const Center(
                child: Text('Chat with Someone'),
              );
            }
            if (snapshots.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            final loadedUsers = snapshots.data!.docs.toList();
            final users = loadedUsers.map((e) {
              return User(
                email: e.get('email'),
                imageUrl: e.get('imageUrl'),
                userId: e.get('userId'),
                userName: e.get('userName'),
              );
            }).toList();

            return SizedBox(
              // margin: EdgeInsets.only(left: 20, right: 20),
              height: 500,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  // double offset = pageOffset - index;
                  var messageTime = DateTime.fromMillisecondsSinceEpoch(
                      (loadedUsers[index]['updatedAt'].seconds) * 1000);

                  final now = DateTime.now();
                  var timeDiff = now.difference(messageTime).inMinutes;
                  var timeText = '$timeDiff minutes';
                  if (timeDiff == 0) {
                    timeText = 'now';
                  } else if (timeDiff > 60) {
                    var hours = (timeDiff ~/ 60).toInt();
                    timeText = '$hours hours';
                    if (hours > 24) {
                      var days = (hours ~/ 24).toInt();
                      if (days == 1) {
                        timeText = 'Yesterday';
                      } else {
                        timeText = '$days days';
                      }
                    }
                  }
                  return CardData(
                    fromUser: currentUser,
                    toUser: users[index],
                    time: timeText,
                  );
                },
              ),
            );
          },
        ),
        const Spacer(),
        const OnlineUsers(),
      ],
    );
  }
}
