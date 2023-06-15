import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/find_friends.dart';
import 'package:global_chat/screens/global_chat.dart';
import 'package:global_chat/screens/recent_chats.dart';
import 'package:global_chat/screens/user_profile.dart';
import 'package:path_provider/path_provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var _isDeleting = false;

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    print(cacheDir.stat());
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

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
          _isDeleting
              ? const CircularProgressIndicator()
              : TextButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isDeleting = true;
                    });
                    await _deleteAppDir();
                    await _deleteCacheDir();
                    setState(() {
                      _isDeleting = false;
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
