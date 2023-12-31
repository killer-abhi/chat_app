import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:global_chat/models/user.dart';

void addNewUser(User user) async {
  final db = FirebaseFirestore.instance;
  db
      .collection('users')
      .doc(user.email)
      .set({...user.toMap(), 'isOnline': true});
}
