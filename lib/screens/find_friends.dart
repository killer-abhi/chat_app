import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                    item.data()['username'].contains(_searchText)))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchTextController,
              onTapOutside: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _searchTextController.clear()); //remove focus
              },
              autocorrect: true,
              decoration: InputDecoration(
                labelText: 'Search by Username or Email',
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: IconButton(
                  onPressed: search,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6 / 7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _loadedUsers.length,
            itemBuilder: (ctx, index) {
              final user = _loadedUsers[index].data();

              return Card(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   color: Theme.of(context).secondaryHeaderColor,
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      foregroundImage: user['image_url'] != null
                          ? NetworkImage(user['image_url'])
                          : null,
                      child: user['image_url'] == null
                          ? Text(
                              user['username'][0],
                              style: const TextStyle(fontSize: 36),
                            )
                          : null,
                    ),
                    Text(
                      user['username'],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_call),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.receipt),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: IconButton(
            onPressed: () {
              _searchTextController.clear();
              search();
            },
            icon: const Icon(Icons.refresh_rounded),
            iconSize: 35,
          ),
        );
      },
    );
  }
}
