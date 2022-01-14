class User {
  late String email;
  String? name;
  bool? emailVerified;
  String? avatar;
  String? token;

  User(
      {required this.email,
      this.name,
      this.emailVerified,
      this.avatar,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    emailVerified = json['emailVerified'];
    avatar = json['avatar'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['emailVerified'] = this.emailVerified;
    data['avatar'] = this.avatar;
    data['token'] = this.token;
    return data;
  }

  @override
  String toString() => 'User { name: $name, email: $email, avatar: $avatar}';
}
