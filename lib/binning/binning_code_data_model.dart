import 'dart:convert';

class CodeDataModel{
  final String productCode;
  final String locationCode;
  final String dateTime;

  const CodeDataModel({
    required this.productCode,
    required this.locationCode,
    required this.dateTime,
  });


  Map<String, dynamic> toMap() {
    return {
      'productCode': productCode,
      'locationCode': locationCode,
      'dateTime': dateTime,
    };
  }

  Map<String, dynamic> toJson() => {
    'productCode': productCode,
    'locationCode': locationCode,
    'dateTime': dateTime,
  };

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'codes{productCode: $productCode, locationCode: $locationCode, dateTime: $dateTime}';
  }

}










// To parse this JSON data, do
//
//     final addProductToServerDbResponse = addProductToServerDbResponseFromJson(jsonString);


AddProductToServerDbResponse addProductToServerDbResponseFromJson(String str) => AddProductToServerDbResponse.fromJson(json.decode(str));

String addProductToServerDbResponseToJson(AddProductToServerDbResponse data) => json.encode(data.toJson());

class AddProductToServerDbResponse {
  AddProductToServerDbResponse({
    required this.status,
    required this.message,
  });

  int status;
  String message;

  factory AddProductToServerDbResponse.fromJson(Map<String, dynamic> json) => AddProductToServerDbResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
