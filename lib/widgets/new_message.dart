import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_chat/models/message.dart';
import 'package:global_chat/models/user.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key, required this.toUser, required this.fromUser})
      : super(key: key);
  final User toUser;
  final User fromUser;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
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

      final newMessage = Message(
          message: enteredMessage,
          fromUser: widget.fromUser.email,
          fromUserName: widget.fromUser.userName,
          toUser: widget.toUser.email,
          fromUserImageUrl: widget.fromUser.imageUrl,
          createdAt: Timestamp.now());

      final collectionName = widget.toUser.email == 'globalUser'
          ? 'globalChat'
          : widget.fromUser.email;

      await FirebaseFirestore.instance
          .collection(collectionName.toString())
          .add(newMessage.getMap());

      if (widget.toUser.email != 'globalUser') {
        await FirebaseFirestore.instance
            .collection(widget.toUser.email)
            .doc(widget.fromUser.email)
            .set(newMessage.getMap());
        await FirebaseFirestore.instance
            .collection(widget.toUser.email)
            .doc(widget.toUser.email)
            .set(newMessage.getMap());
      }
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
