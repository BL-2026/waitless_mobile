class MyUser {
  String? uid;
  String? email;

  MyUser({this.uid, this.email});

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        uid: json['uid']?.toString(),
        email: json['email']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
      };

  @override
  String toString() => 'User(uid: $uid, email: $email)';
}
