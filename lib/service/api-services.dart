import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../audit/audit_code_data_model.dart';
import '../binning/binning_code_data_model.dart';
import '../common-methods.dart';
import 'api-urls.dart';

class ApiService {
  static Uri buildUrl(String urlString, String method) {
    if (method == "put") {
      print("url====>   ${urlString}/${ApiUrls.userId}");
      return Uri.parse("${urlString}/${ApiUrls.userId}");
    } else {
      print("url====>   ${urlString}");
      return Uri.parse(urlString);
    }
  }

  static Future<String> postMethod(dynamic request, String url) async {
    ApiUrls.loaderOnBtn = true;
    final result;
    try {
      (kIsWeb)
          ? result = true
          : result = await InternetAddress.lookup('example.com');

      var condition = (kIsWeb)
          ? true
          : result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (condition) {
        print("request post :: $request");
        var response = await http.post(buildUrl(url, "post"),
            body: request,
            headers: {
              "Accept": "application/json",
              "Access-Control-Allow-Origin": "*"
            });

        if (response.statusCode == 200 || response.statusCode == 404) {
          ApiUrls.loaderOnBtn = false;
          return response.body;
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        return "Exception";
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      return 'Exception';
    }
    return 'Exception';
  }
  /*static Future<String> postMethod(dynamic request,String url) async {
    ApiUrls.loaderOnBtn = true;
    final result;
    try {
      (kIsWeb) ?  result = true : result = await InternetAddress.lookup('example.com');

      var condition = (kIsWeb) ? true : result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (condition) {
        var response = await http.post(
            buildUrl(url,"post"), body: request, headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });

        if (response.statusCode == 200 || response.statusCode == 404) {
          ApiUrls.loaderOnBtn = false;
          return response.body;
        }
      }else{
        ApiUrls.loaderOnBtn = false;
        return "Exception";
      }
    }on SocketException catch (_) {
      ApiUrls.loaderOnBtn =false;
      return 'Exception';
    }
    return 'Exception';
  }*/

  static Future<String> putMethod(dynamic request, String url) async {
    print("ApiUrls.profileToken ${ApiUrls.profileToken}");
    ApiUrls.loaderOnBtn = true;
    final result;
    try {
      (kIsWeb)
          ? result = true
          : result = await InternetAddress.lookup('example.com');

      var condition = (kIsWeb)
          ? true
          : result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (condition) {
        var response = await http
            .put(buildUrl(url, "put"), body: request.toJson(), headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "x-access-token": ApiUrls.profileToken
        });

        if (response.statusCode == 200 || response.statusCode == 404) {
          ApiUrls.loaderOnBtn = false;
          return response.body;
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        return "Exception";
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      return 'Exception';
    }
    return 'Exception';
  }

  static Future<String> getMethod(String url) async {
    var response = await http.get(buildUrl(url, "get"), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    return response.body;
  }

  static Future<String> uploadImageAPi(requestFields, requestFiles, uri) async {
    ApiUrls.loaderOnBtn = true;
    final result;
    var request = http.MultipartRequest('POST', buildUrl(uri, "multipart"));

    request.fields.addAll(requestFields);

    if (requestFiles.length != 0) {
      for (var i = 0; i < requestFiles.length; i++) {
        request.files.add(requestFiles[i]);
      }
    }
    try {
      (kIsWeb)
          ? result = true
          : result = await InternetAddress.lookup('example.com');

      var condition = (kIsWeb)
          ? true
          : result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (condition) {
        var response = await request.send();
        if (response.statusCode == 200 || response.statusCode == 400) {
          ApiUrls.loaderOnBtn = false;
          var responseData = await response.stream.toBytes();
          var result = String.fromCharCodes(responseData);
          return result;
        } else {
          ApiUrls.loaderOnBtn = false;
          throw Exception("Failed to load data");
        }
      } else {
        ApiUrls.loaderOnBtn = false;
        return "Exception";
      }
    } on SocketException catch (_) {
      ApiUrls.loaderOnBtn = false;
      return 'Exception';
    }
  }

  static List<CodeDataModel> createListForBinningProduct(maps) {
    return List.generate(maps.length, (i) {
      print("i :$i");
      print("maps.length :${maps.length}");
      return CodeDataModel(
        productCode: maps[i]['productCode'],
        locationCode: maps[i]['locationCode'],
        dateTime: maps[i]['dateTime'],
      );
    });
  }

  static createListForAuditProduct(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      print("i :$i");
      print("maps.length :${maps.length}");
      return AuditRequestDataModel(
          productCode: maps[i]["productCode"],
          locationCode: maps[i]["locationCode"],
          dateTime: maps[i]["dateTime"],
          vendor: maps[i]["vendor"],
          matDesc: maps[i]["matDesc"],
          poNo: maps[i]["poNo"],
          itemCode: maps[i]["itemCode"],
          dept: maps[i]["dept"],
          qty: maps[i]["qty"],
          sieDate: maps[i]["sieDate"], //.toIso8601String(),
          sieNo: maps[i]["sieNo"],
          isProductChecked: maps[i]["isProductChecked"],
          remark: maps[i]["remark"]);
    });
  }

  static Future saveToServerDb(List<dynamic>? codeList, String url) async {
    if (codeList != null || codeList != []) {
      for (var i = 0; i < codeList!.length; i++) {
        print('add Product To Server res :: ${codeList[i]}');
        await ApiService.postMethod(codeList[i].toMap(), url).then((value) {
          print('add Product To Server res :: ${value}');
          var resData = addProductToServerDbResponseFromJson(value);
          showToast(resData.message, "");
        });
      }
    }
  }
}
