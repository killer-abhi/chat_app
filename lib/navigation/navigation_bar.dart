import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/auth/active_status.dart';
import 'package:global_chat/providers/current_user.dart';
import 'package:global_chat/screens/find_friends.dart';
import 'package:global_chat/screens/global_chat.dart';
import 'package:global_chat/screens/user_profile.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userDetails =
        Provider.of<CurrentUserProvider>(context, listen: false).currUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatWave'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseFirestore.instance
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
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(
              // child: const Text('Chats'),
              icon: Icon(Icons.wechat),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.cloud_outlined),
            ),
            Tab(
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        children: [
          const ActiveStatus(),
          const FindFriendsScreen(),
          const GlobalChatScreen(),
          UserProfileScreen(
            userDetails: userDetails,
          ),
        ],
      ),
    );
  }
}
