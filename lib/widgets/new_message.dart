import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key, required this.toUser, required this.fromUser})
      : super(key: key);
  final dynamic toUser;
  final dynamic fromUser;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // _NewMessageState({required this.toUser});
  // final dynamic toUser;

  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void submitMessage() async {
      final enteredMessage = _messageController.text;
      if (enteredMessage.trim().isEmpty) {
        return;
      }

      _messageController.clear();
      FocusScope.of(context).unfocus();

      final newChatMessage = {
        'message': enteredMessage,
        'createdAt': Timestamp.now(),
        'fromUserId': widget.fromUser['userId'],
        'fromUsername': widget.fromUser['username'],
        'userImage': widget.fromUser['image_url'],
        'toUserId':
            widget.toUser == 'globalUser' ? 'global' : widget.toUser['userId'],
        'toUsername': widget.toUser == 'globalUser'
            ? 'global'
            : widget.toUser['username'],
      };

      final collectionName = widget.toUser == 'globalUser'
          ? 'globalChat'
          : BigInt.parse(widget.toUser['userId']) +
              BigInt.parse(widget.fromUser['userId']);

      await FirebaseFirestore.instance
          .collection(collectionName.toString())
          .add(newChatMessage);
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _messageController,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: true,
        enableSuggestions: true,
        onTapOutside: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => _messageController.clear()); //remove focus
        },
        decoration: InputDecoration(
          labelText: 'Send a message ...',
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: IconButton(
            onPressed: submitMessage,
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
