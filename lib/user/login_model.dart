// To parse this JSON data, do
//
//     final loginRequestModel = loginRequestModelFromJson(jsonString);

import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) => LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) => json.encode(data.toJson());

class LoginRequestModel {
  LoginRequestModel({
    required this.employeeid,
    required this.password,
  });

  String employeeid;
  String password;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => LoginRequestModel(
    employeeid: json["employeeid"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "employeeid": employeeid,
    "password": password,
  };
}


// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);



LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.status,
    required this.message,
     this.data,
  });

  int status;
  String message;
  Data? data;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    if(json["data"] == null){
      return LoginModel(
        status: json["status"],
        message: json["message"]
      );
    }else{
      return LoginModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );
    }

  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.token,
     required this.id,
  });

  String token;
  String id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
  };
}
