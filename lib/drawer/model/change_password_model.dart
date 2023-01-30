// To parse this JSON data, do
//
//     final changePasswordRequest = changePasswordRequestFromJson(jsonString);

import 'dart:convert';

ChangePasswordRequest changePasswordRequestFromJson(String str) => ChangePasswordRequest.fromJson(json.decode(str));

String changePasswordRequestToJson(ChangePasswordRequest data) => json.encode(data.toJson());

class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.id,
    required this.currentPassword,
    required this.password,
  });

  String id;
  String currentPassword;
  String password;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => ChangePasswordRequest(
    id: json["id"],
    currentPassword: json["currentPassword"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currentPassword": currentPassword,
    "password": password,
  };
}



// To parse this JSON data, do
//
//     final changePasswordResponse = changePasswordResponseFromJson(jsonString);


ChangePasswordResponse changePasswordResponseFromJson(String str) => ChangePasswordResponse.fromJson(json.decode(str));

String changePasswordResponseToJson(ChangePasswordResponse data) => json.encode(data.toJson());

class ChangePasswordResponse {
  ChangePasswordResponse({
    required this.status,
    required this.message,
  });

  int status;
  String message;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}



