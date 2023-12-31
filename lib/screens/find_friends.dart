import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/screens/chat_screen.dart';
import 'package:global_chat/models/user.dart' as users;

class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({Key? key}) : super(key: key);

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final _searchTextController = TextEditingController();
  final _authenticatedUser = FirebaseAuth.instance.currentUser!;
  var _loadedUsers = [];
  var _searchText = '';
  void search() {
    setState(() {
      _searchText = _searchTextController.value.text;
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (ctx, userSnapshots) {
        if (userSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!userSnapshots.hasData || userSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Users Found'),
          );
        }
        if (userSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        _loadedUsers = userSnapshots.data!.docs
            .where((item) =>
                item.data()['email'] != _authenticatedUser.email &&
                (item.data()['email'].contains(_searchText) ||
                    item.data()['userName'].contains(_searchText)))
            .toList();

        final List<users.User> userList = [];
        _loadedUsers.forEach((element) {
          userList.add(
            users.User(
              email: element['email'],
              imageUrl: element['imageUrl'],
              userId: element['userId'],
              userName: element['userName'],
              isOnline: element['isOnline'] ? element['isOnline'] : false,
            ),
          );
        });
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchTextController,
                // onTapOutside: (_) {
                //   FocusScope.of(context).requestFocus(FocusNode());
                //   WidgetsBinding.instance.addPostFrameCallback(
                //       (_) => _searchTextController.clear()); //remove focus
                // },
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: 'Search by Username or Email',
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      search();
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            if (userList.isEmpty) const Text('No Users Found'),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: userList.length,
                itemBuilder: (ctx, index) {
                  final user = userList[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Hero(
                          tag: user.email,
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: NetworkImage(user.imageUrl),
                            child: user.imageUrl == 'null'
                                ? Text(
                                    user.userName[0],
                                    style: const TextStyle(fontSize: 36),
                                  )
                                : null,
                          ),
                        ),
                        Text(
                          user.userName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.group_add),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ChatScreen(
                                    toUser: user,
                                  ),
                                ));
                              },
                              icon: const Icon(Icons.message_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _searchTextController.clear();
                    search();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  iconSize: 35,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
