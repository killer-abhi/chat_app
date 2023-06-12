import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentChatsScreen extends StatelessWidget {
  const RecentChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final authenticatedUser = FirebaseAuth.instance.currentUser!;
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
    //     builder:(context, snapshot){
    //       if(snapshot)
    //     }
    //   );
    return ListView.builder(
      itemCount: 25,
      itemBuilder: (context, index) => ListTile(
        key: ValueKey(index),
        title: Text(
          'User1',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        isThreeLine: true,
        tileColor: index % 2 == 0
            ? null
            : Theme.of(context).colorScheme.primaryContainer,
        subtitle: const Text('Chat 1'),
        horizontalTitleGap: 20,
        minVerticalPadding: 20,
        onTap: () => print(index),
        leading: const CircleAvatar(
          foregroundColor: Colors.amberAccent,
          radius: 25,
          child: Text('A'),
        ),
        trailing: Padding(
          padding: EdgeInsets.only(left: 0, right: 30, top: 10),
          child: Text('Yesterday'),
        ),
      ),
      // children: [
      //   ListTile(
      //     title: const Text('User1'),
      //     isThreeLine: true,
      //     subtitle: const Text('Chat 1'),
      //     horizontalTitleGap: 20,
      //     minVerticalPadding: 20,
      //     onTap: () => print('clicked'),
      //     leading: const CircleAvatar(
      //       foregroundColor: Colors.amberAccent,
      //       radius: 25,
      //       child: Text('A'),
      //     ),
      //     trailing: const Text('User1'),
      //   ),
      //   ListTile(
      //     title: const Text('User1'),
      //     isThreeLine: true,
      //     subtitle: const Text('Chat 1'),
      //     horizontalTitleGap: 20,
      //     minVerticalPadding: 20,
      //     tileColor: Colors.greenAccent,
      //     onTap: () => print('clicked'),
      //     leading: const CircleAvatar(
      //       foregroundColor: Colors.amberAccent,
      //       radius: 25,
      //       child: Text('A'),
      //     ),
      //     trailing: const Text('User1'),
      //   ),
      // ],
    );
  }
}
