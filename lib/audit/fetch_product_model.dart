// To parse this JSON data, do
//
//     final auditProductDetailsModel = auditProductDetailsModelFromJson(jsonString);

import 'dart:convert';

AuditProductDetailsModel auditProductDetailsModelFromJson(String str) => AuditProductDetailsModel.fromJson(json.decode(str));

String auditProductDetailsModelToJson(AuditProductDetailsModel data) => json.encode(data.toJson());

class AuditProductDetailsModel {
  AuditProductDetailsModel({
    required this.status,
    required this.message,
    this.fetchProducts,
  });

  int status;
  String message;
  List<FetchProduct>? fetchProducts;

  factory AuditProductDetailsModel.fromJson(Map<String, dynamic> json) {
    if(json["fetchProducts"] == null){
      return AuditProductDetailsModel(
        status: json["status"],
        message: json["message"]
      );
    }else{
      return AuditProductDetailsModel(
        status: json["status"],
        message: json["message"],
        fetchProducts: List<FetchProduct>.from(json["fetchProducts"].map((x) => FetchProduct.fromJson(x))),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "fetchProducts": List<dynamic>.from(fetchProducts!.map((x) => x.toJson())),
  };
}

class FetchProduct {
  FetchProduct({
    required this.vendor,
    required this.matDesc,
    required this.poNo,
    required this.itemCode,
    required this.dept,
    required this.qty,
    required this.sieDate,
    required this.sieNo,
    required this.product,
    required this.location,
  });

  String vendor;
  String matDesc;
  String poNo;
  String itemCode;
  String dept;
  String qty;
  String sieDate;
  String sieNo;
  String product;
  String location;

  factory FetchProduct.fromJson(Map<String, dynamic> json) => FetchProduct(
    vendor: json["vendor"],
    matDesc: json["matDesc"],
    poNo: json["poNo"],
    itemCode: json["itemCode"],
    dept: json["dept"],
    qty: json["qty"],
    sieDate: json["sieDate"],
    sieNo: json["sieNo"],
    product: json["product"],
    location: json["location"],
  );



  Map<String, dynamic> toJson() => {
    "vendor": vendor,
    "matDesc": matDesc,
    "poNo": poNo,
    "itemCode": itemCode,
    "dept": dept,
    "qty": qty,
    "sieDate": sieDate,//.toIso8601String(),
    "sieNo": sieNo,
    "product": product,
    "location": location,
  };
}
