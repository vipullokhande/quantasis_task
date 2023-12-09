class UserModel {
  final String uid;
  final String name;
  final String email;

  const UserModel({
    required this.name,
    required this.uid,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
      };
}
