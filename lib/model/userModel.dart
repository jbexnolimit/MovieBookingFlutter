// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
   required this.user,
    required this.token,
  });

  User user;
  String token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    user: User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "token": token,
  };
}

class User {
  User({
    required this.email,
    required this.hashValue,
    required this.account,
    required this.date,
    required this.id,
    required this.v,
  });

  String email;
  String hashValue;
  Account account;
  Date date;
  String id;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    hashValue: json["hashValue"],
    account: Account.fromJson(json["account"]),
    date: Date.fromJson(json["date"]),
    id: json["_id"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "hashValue": hashValue,
    "account": account.toJson(),
    "date": date.toJson(),
    "_id": id,
    "__v": v,
  };
}

class Account {
  Account({
    required this.profile,
    required this.verified,
    required this.role,
  });

  Profile profile;
  bool verified;
  String role;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    profile: Profile.fromJson(json["profile"]),
    verified: json["verified"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "profile": profile.toJson(),
    "verified": verified,
    "role": role,
  };
}

class Profile {
  Profile({
    required this.imageUrl,
    required this.name,
    required this.givenName,
    required this.familyName,
  });

  String imageUrl;
  String name;
  String givenName;
  String familyName;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    imageUrl: json["imageUrl"],
    name: json["name"],
    givenName: json["givenName"],
    familyName: json["familyName"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "name": name,
    "givenName": givenName,
    "familyName": familyName,
  };
}

class Date {
  Date({
    required this.createdAt,
  });

  DateTime createdAt;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
  };
}
