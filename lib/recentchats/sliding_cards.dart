import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/recentchats/card_data.dart';
import 'package:global_chat/widgets/chat_messages.dart';
import 'card_content.dart';
import 'card_model.dart';

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
    final currentUserEmail =
        Auth.FirebaseAuth.instance.currentUser!.email.toString();
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection(currentUserEmail).snapshots(),
      builder: (context, snapshots) {
        // if (snapshots.connectionState == ConnectionState.waiting) {
        //   return const CircularProgressIndicator();
        // }
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
        final _loadedUsers = snapshots.data!.docs.toList();
        final users = _loadedUsers.map((e) {
          return User(
              email: e.get('email'),
              imageUrl: e.get('imageUrl'),
              userId: e.get('userId'),
              userName: e.get('userName'));
        }).toList();

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: PageView.builder(
            clipBehavior: Clip.none,
            controller: pageController,
            itemCount: users.length,
            itemBuilder: (context, index) {
              // double offset = pageOffset - index;

              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double pageOffset = 0;
                  if (pageController.position.haveDimensions) {
                    pageOffset = pageController.page! - index;
                  }
                  double gauss =
                      math.exp(-(math.pow((pageOffset.abs() - 0.5), 2) / 0.08));
                  return Transform.translate(
                    offset: Offset(-32 * gauss * pageOffset.sign, 0),
                    child: CardData(user: users[index]),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
