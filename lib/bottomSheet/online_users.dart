import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:global_chat/models/user.dart';
import 'package:global_chat/bottomSheet/bottom_sheet.dart';

class OnlineUsers extends StatefulWidget {
  const OnlineUsers({Key? key}) : super(key: key);

  @override
  State<OnlineUsers> createState() => _OnlineUsersState();
}

class _OnlineUsersState extends State<OnlineUsers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshots.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        final loadedUsers = snapshots.data!.docs.toList().where((element) =>
            element.get('email') !=
            auth.FirebaseAuth.instance.currentUser!.email);
        var users = loadedUsers.map((e) {
          return User(
            userName: e['userName'],
            email: e['email'],
            userId: e['userId'],
            imageUrl: e['imageUrl'],
            isOnline: e['isOnline'],
          );
        }).toList();

        users = users.where((e) => e.isOnline == true).toList();
        return users.length > 0 ? BottomSheetModal(users: users) : Text('');
      },
    );
  }
}
