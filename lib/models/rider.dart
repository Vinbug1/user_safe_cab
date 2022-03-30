// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

Rider userFromJson(String str) => Rider.fromJson(json.decode(str));

String userToJson(Rider data) => json.encode(data.toJson());

class Rider {
  Rider({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.password,
  });

  String id;
  String fullName;
  String phone;
  String email;
  String password;

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
    id: json["id"],
    fullName: json["fullName"],
    phone: json["phone"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "phone": phone,
    "email": email,
    "password": password,
  };
}
