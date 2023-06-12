import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/find_friends.dart';
import 'package:global_chat/screens/global_chat.dart';
import 'package:global_chat/screens/recent_chats.dart';
import 'package:global_chat/screens/user_profile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatApp'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton.icon(
            onPressed: () {
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
        controller: _tabController,
        children: const [
          RecentChatsScreen(),
          FindFriendsScreen(),
          GlobalChatScreen(),
          UserProfileScreen(),
        ],
      ),
      // floatingActionButton: ElevatedButton.icon(
      //   onPressed: () {},
      //   icon: const Icon(Icons.start),
      //   label: const Text('Chat'),
      // ),
    );
  }
}
