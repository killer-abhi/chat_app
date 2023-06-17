import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = LocalStorage('chatApp');

void addNewUser(Map<String, dynamic> user) async {
  final db = FirebaseFirestore.instance;
  db.collection('users').doc(user['email']).set(user);

  // await storage.ready;
  // await storage.setItem('currentUser', user);
}

Future getCurrentUser() async {
  await storage.ready;
  final currentUser = await storage.getItem('currentUser');

  return currentUser;
}
