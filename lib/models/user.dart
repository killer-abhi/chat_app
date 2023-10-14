class User {
  const User(
      {required this.email,
      required this.imageUrl,
      required this.userId,
      required this.userName});

  final String userName;
  final String imageUrl;
  final String userId;
  final String email;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imageUrl': imageUrl,
      'userId': userId,
      'userName': userName,
    };
  }
}
