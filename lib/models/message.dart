import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  const Message(
      {required this.message,
      required this.fromUser,
      required this.toUser,
      required this.fromUserImageUrl,
      required this.fromUserName,
      required this.createdAt});

  final String message;
  final String fromUser;
  final String toUser;
  final String fromUserImageUrl;
  final String fromUserName;
  final Timestamp createdAt;

  Map<String, dynamic> getMap() {
    return {
      'message': message,
      'fromUser': fromUser,
      'toUser': toUser,
      'fromUserImageUrl': fromUserImageUrl,
      'fromUserName': fromUserName,
      'createdAt': createdAt,
    };
  }
}
