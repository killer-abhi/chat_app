class User {
  const User(
      {required this.email,
      required this.imageUrl,
      required this.userId,
      required this.userName,
      this.isOnline = false});

  final String userName;
  final String imageUrl;
  final String userId;
  final String email;
  final bool isOnline;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imageUrl': imageUrl,
      'userId': userId,
      'userName': userName,
    };
  }
}
