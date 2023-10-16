import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:global_chat/providers/current_user.dart';
import 'package:global_chat/recentchats/sliding_cards.dart';
import 'package:provider/provider.dart';

class ActiveStatus extends StatefulWidget {
  const ActiveStatus({Key? key}) : super(key: key);

  @override
  State<ActiveStatus> createState() => _ActiveStatusState();
}

class _ActiveStatusState extends State<ActiveStatus>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((doc) {
        if (doc.data()!.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(doc.get('email').toString())
              .update({'isOnline': true});
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((doc) {
        if (doc.data()!.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(doc.get('email').toString())
              .update({'isOnline': false});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrentUserProvider>(context, listen: false);
    provider.fetchUser();
    return const SlidingCardsView();
  }
}
