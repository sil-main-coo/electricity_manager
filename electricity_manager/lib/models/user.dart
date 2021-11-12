import 'dart:convert';

class User {
  String? useName, password;
  UserProfile? profile;

  User({this.password, this.useName, this.profile});

  factory User.fromJson(Map<String, dynamic> json, [String? id]) {
    return User(
        password: json['password'],
        useName: json['userName'],
        profile: json['profile'] != null
            ? UserProfile.fromJson(Map<String, dynamic>.from(json['profile']))
            : null);
  }

  factory User.fromRawData(String jsonString) {
    return User.fromJson(jsonDecode(jsonString));
  }

  String toRawData() {
    return jsonEncode(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'password': this.password,
      'userName': this.useName,
      'profile': this.profile?.toJson()
    };
  }
}

class UserProfile {
  String? id, fullName, role, avatar, phone;

  UserProfile(
      {this.id,
      this.fullName,
      this.role = 'EMPLOYEE',
      this.avatar,
      this.phone});

  factory UserProfile.fromJson(Map<String, dynamic> json, [String? id]) {
    return UserProfile(
        id: id ?? json['id'],
        fullName: json['fullName'],
        avatar: json['avatar'],
        phone: json['phone'],
        role: json['role']);
  }

  factory UserProfile.fromRawData(String jsonString) {
    return UserProfile.fromJson(jsonDecode(jsonString));
  }

  String toRawData() {
    return jsonEncode(this.toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': this.fullName,
      'role': this.role,
      'avatar': this.avatar,
      'id': this.id,
      'phone': this.phone,
    };
  }
}
