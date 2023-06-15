import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  final _userNameController = TextEditingController();
  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.purple,
            foregroundColor: Colors.green,
            foregroundImage: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/chat-app-f8268.appspot.com/o/user_images%2FvYWbKZ8YuecLjHteCH9Wq3YKWJ42.jpg?alt=media&token=52b778ae-818e-40d1-bf62-550b690d7a9a'),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_a_photo),
            label: Text('Change Photo'),
          ),
          TextField(
            // initialValue: 'Abhishek Kumar',
            controller: _userNameController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Username',
              suffix: IconButton(
                onPressed: () {
                  print('pressed');
                },
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          TextFormField(
            initialValue: 'email',
            enabled: false,
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.update),
            label: Text('Update Profile'),
          ),
        ],
      ),
    );
  }
}
