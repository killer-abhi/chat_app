import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/contact_list.dart';
import 'package:global_chat/screens/find_friends.dart';
import 'package:global_chat/screens/global_chat.dart';
import 'package:global_chat/screens/recent_chats.dart';
import 'package:global_chat/screens/user_profile.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var _selectedIndex = 0;

  var _isDeleting = false;

  void logout() async {
    setState(() {
      _isDeleting = true;
    });
    FirebaseAuth.instance.signOut();
    setState(() {
      _isDeleting = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatWave'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          _isDeleting
              ? const CircularProgressIndicator()
              : TextButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            // Tab(
            //   // child: const Text('Chats'),
            //   icon: Icon(Icons.wechat),
            // ),
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
        children: const [
          // RecentChatsScreen(),
          FindFriendsScreen(),
          GlobalChatScreen(),
          UserProfileScreen(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const ContactListScreen()));
                },
                icon: Icon(
                  Icons.messenger,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
            )
          : null,
    );
  }
}
