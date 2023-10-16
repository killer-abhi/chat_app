class User {
  User(
      {required this.email,
      required this.imageUrl,
      required this.userId,
      required this.userName,
      this.isOnline = false});

  String userName;
  String imageUrl;
  String userId;
  String email;
  bool isOnline;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imageUrl': imageUrl,
      'userId': userId,
      'userName': userName,
    };
  }
}
