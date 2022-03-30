// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    this.id,
    this.fullName,
    this.phone,
    this.imageUrl,
    this.sex,
    this.carMake,
    this.driversLicense,
  });

  String id;
  String fullName;
  String phone;
  String imageUrl;
  String sex;
  String carMake;
  String driversLicense;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    fullName: json["fullName"],
    phone: json["phone"],
    imageUrl: json["imageUrl"],
    sex: json["sex"],
    carMake: json["carMake"],
    driversLicense: json["drivers_license"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "phone": phone,
    "imageUrl": imageUrl,
    "sex": sex,
    "carMake": carMake,
    "drivers_license": driversLicense,
  };
}
