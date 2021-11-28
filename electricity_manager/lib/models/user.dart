import 'dart:convert';
import 'dart:typed_data';
import 'package:electricity_manager/utils/commons/role_constants.dart';

class User {
  String? useName, password;
  DateTime? createAt, updateAt;
  UserProfile? profile;

  User(
      {this.password,
      this.useName,
      this.profile,
      DateTime? createAt,
      DateTime? updateAt}) {
    this.createAt = createAt ?? DateTime.now();
    this.updateAt = updateAt ?? DateTime.now();
  }

  factory User.fromJson(Map<String, dynamic> json, [String? id]) {
    return User(
        password: json['password'],
        useName: json['userName'],
        createAt: json['createAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['createAt'])
            : null,
        updateAt: json['updateAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['updateAt'])
            : null,
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
      'createAt': this.createAt?.millisecondsSinceEpoch,
      'updateAt': this.updateAt?.millisecondsSinceEpoch,
      'profile': this.profile?.toJson()
    };
  }
}

class UserProfile {
  String? id, fullName, role, avatar, phone, roleName, signImageURL;
  Uint8List? signImage;

  String get roleString => RoleConstants.mapRoleToString(roleName);

  bool get isAdmin => role == RoleConstants.ADMIN;

  UserProfile(
      {this.id,
      this.signImageURL,
      this.fullName,
      this.roleName,
      this.role = 'EMPLOYEE',
      this.avatar,
      this.phone});

  factory UserProfile.fromJson(Map<String, dynamic> json, [String? id]) {
    return UserProfile(
        id: id ?? json['id'],
        signImageURL: json['signImageURL'],
        fullName: json['fullName'],
        roleName: json['roleName'],
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

  Map<String, dynamic> toImagesJson() {
    return {
      'signImageURL': signImageURL
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': this.fullName,
      'role': this.role,
      'avatar': this.avatar,
      'id': this.id,
      'phone': this.phone,
      'roleName': this.roleName
    };
  }

  @override
  String toString() {
    return this.fullName != null ? '${this.fullName} ($roleString)' : '';
  }
}
