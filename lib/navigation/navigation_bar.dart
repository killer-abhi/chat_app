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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userDetails =
        Provider.of<CurrentUserProvider>(context, listen: false).currUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatWave',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    userDetails: userDetails,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
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
          ],
        ),
      ),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        children: const [
          ActiveStatus(),
          FindFriendsScreen(),
          GlobalChatScreen(),
        ],
      ),
      backgroundColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
    );
  }
}
