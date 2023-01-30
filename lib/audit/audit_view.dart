import 'package:flutter/material.dart';
import 'package:jsw/audit/audit_code_data_model.dart';
import 'package:jsw/main.dart';
import 'package:jsw/service/db-helper.dart';
import 'fetch_product_model.dart';

class AuditView extends StatefulWidget {
  @override
  _AuditViewState createState() => _AuditViewState();
}

class _AuditViewState extends State<AuditView> {
  /*{
  "status": 1,
  "message": "success",
  "fetchProducts": [
  {
  "vendor": "1",
  "matDesc": "nearMe6784b20",
  "poNo": "Home Solution",
  "itemCode": "6564556",
  "dept": "jsw",
  "qty": "2",
  "sieDate": "2022-07-08 16:56:54",
  "sieNo": "200",
  "product": "p1",
  "location": "l10"
  },
  {
  "vendor": "1",
  "matDesc": "nearMe6784b20",
  "poNo": "Home Solution",
  "itemCode": "6564556",
  "dept": "jsw",
  "qty": "2",
  "sieDate": "2022-07-08 16:56:54",
  "sieNo": "200",
  "product": "p1",
  "location": "l10"
  }
  ]
  }*/

  List<AuditRequestDataModel> auditReqDataList = [];

  String jsonString =
      "{\"status\":1,\"message\":\"success\",\"fetchProducts\":[{\"vendor\":\"1\",\"matDesc\":\"nearMe6784b20\",\"poNo\":\"HomeSolution\",\"itemCode\":\"6564556\",\"dept\":\"jsw\",\"qty\":\"2\",\"sieDate\":\"2022-07-0816:56:54\",\"sieNo\":\"200\",\"product\":\"p1\",\"location\":\"l10\"},{\"vendor\":\"1\",\"matDesc\":\"nearMe6784b20\",\"poNo\":\"HomeSolution\",\"itemCode\":\"6564556\",\"dept\":\"jsw\",\"qty\":\"2\",\"sieDate\":\"2022-07-0816:56:54\",\"sieNo\":\"200\",\"product\":\"p2\",\"location\":\"l10\"}]}";


  List<FetchProduct>? productDetailsList;
  final Map<String, bool> _selection = {};
  final Map<String, String> remark = {};

  var remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchProductDetailsApi();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Audit'),
          centerTitle: false,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.sync))
          ]),
      body: createServiceListview(context),
    );
  }





  Widget createServiceListview(context) {
    return SafeArea(
      child: (productDetailsList != null && productDetailsList!.isNotEmpty)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: productDetailsList?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ExpansionTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(onPressed: () {
                              openRemarkTextField(productDetailsList![index].product);
                            }, child: const Text("Remark")),
                            Checkbox(value: _selection[productDetailsList![index].product]??false, onChanged: (val) {
                              print(productDetailsList![index].product);
                              _selection[productDetailsList![index].product] = val!;
                              print(_selection[productDetailsList![index].product]);
                              print(_selection);
                              print(_selection["p1"]);
                              print(index);
                              print(AuditRequestDataModel(productCode: productDetailsList![index].product,
                                  locationCode: productDetailsList![index].location, dateTime: DateTime.now().toIso8601String(), vendor: productDetailsList![index].vendor,
                                  matDesc: productDetailsList![index].matDesc, poNo: productDetailsList![index].poNo,
                                  itemCode: productDetailsList![index].itemCode, dept: productDetailsList![index].dept, qty: productDetailsList![index].qty,
                                  sieDate: productDetailsList![index].sieDate,
                                  sieNo: productDetailsList![index].sieNo, isProductChecked: _selection[productDetailsList![index].product].toString(), remark: "remark$index"));

                              auditReqDataList.add(AuditRequestDataModel(productCode: productDetailsList![index].product,
                                  locationCode: productDetailsList![index].location, dateTime: DateTime.now().toIso8601String(), vendor: productDetailsList![index].vendor,
                                   matDesc: productDetailsList![index].matDesc, poNo: productDetailsList![index].poNo,
                                  itemCode: productDetailsList![index].itemCode, dept: productDetailsList![index].dept, qty: productDetailsList![index].qty,
                                  sieDate: productDetailsList![index].sieDate,
                                  sieNo: productDetailsList![index].sieNo, isProductChecked: _selection[productDetailsList![index].product].toString() ?? "false", remark: "remark$index"));

                              print(auditReqDataList);
                              //dbHelper.insert(row, DatabaseHelper.productDetailsTable);
                              setState((){});
                            }),
                            //ElevatedButton(onPressed: (){}, child: Text("Done"))
                            SizedBox.fromSize(
                              size: Size(60, 30),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.blue,
                                  child: InkWell(
                                    splashColor: Colors.green,
                                    onTap: () {
                                      showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          content: Text("please give remark or check the product before save"),
                                          actions: [
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text("Cancel")),
                                            TextButton(onPressed: (){
                                              insertAuditInLocalDb(AuditRequestDataModel(productCode: productDetailsList![index].product,
                                                  locationCode: productDetailsList![index].location, dateTime: DateTime.now().toIso8601String(), vendor: productDetailsList![index].vendor,
                                                  matDesc: productDetailsList![index].matDesc, poNo: productDetailsList![index].poNo,
                                                  itemCode: productDetailsList![index].itemCode, dept: productDetailsList![index].dept, qty: productDetailsList![index].qty,
                                                  sieDate: productDetailsList![index].sieDate,
                                                  sieNo: productDetailsList![index].sieNo, isProductChecked: _selection[productDetailsList![index].product].toString(), remark: remark[productDetailsList![index].product].toString()));
                                            }, child: Text("OK")),
                                          ],
                                        );
                                      });

                                    },
                                    child: const Center(child: Text("SAVE",style: TextStyle(color: Colors.white),)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        title: Text(productDetailsList![index].product),
                        children: productDetailsList![index]
                            .toJson()
                            .entries
                            .map((entry) {
                          return ListTile(
                            tileColor: Colors.white24,
                            title: Text('${entry.key} : ${entry.value}'),
                          );
                        }).toList()),
                  ),
                );
              })
          : const Center(
              child: Text(
                'No results found',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }

  


  /*Widget createServiceListview(context) {
    return SafeArea(
      child: (productDetailsList != null && productDetailsList!.isNotEmpty)
          ? ListView.builder(
          shrinkWrap: true,
          itemCount: productDetailsList?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(productDetailsList![index].product),
                  subtitle: TextButton(child: Text("Remark"),onPressed: (){},),
                  trailing: Checkbox(value: false, onChanged: (bool? value) {  },),
                  onTap:() {
                    ExpansionTile(
                      title: Text(productDetailsList![index].product),
                      children: productDetailsList![index]
                          .toJson()
                          .entries
                          .map((entry) {
                        _selection[entry.key] =
                            _selection[entry.key] ?? false;
                        return CheckboxListTile(
                          tileColor: Colors.white24,
                          title: Text('${entry.key} : ${entry.value}'),
                          value: _selection[entry.key],
                          onChanged: (val) {
                            setState(() {
                              _selection[entry.key] = val!;
                            });
                          },
                        );
                      }).toList());
                  },
                ),
              ),
            );
          })
          : const Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }*/

  Future<void> fetchProductDetailsApi() async {
    var resData = auditProductDetailsModelFromJson(jsonString);
    if (resData.status == 1) {
      print('product.value :: ${resData.toJson()}');
      productDetailsList = resData.fetchProducts;
    } else {
      productDetailsList = [];
    }
    /*await ApiService.getMethod(ApiUrls.androidfetchRegisterAsPartnerService)
        .then((value) async {
      var resData = fetchRegisterAsPartnerServiceResponseFromJson(value);
      showLoader.value = false;
      if (resData.status == 1) {
        print('foundServices.value :: ${resData.toJson()}');
        updateServiceList(resData.fetchRegisterAsPartnerService);
      } else {
        partnerServiceList = [];
        foundServices.value = partnerServiceList;
      }
    });*/
  }

  void openRemarkTextField(String product) {
    showDialog(
        context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Remark for $product"),
        content:  TextField(
          controller: remarkController,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder()
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel")),
          TextButton(onPressed: (){
            print(product);
            remark[product] = remarkController.text;
            print("remark ${remark}");
            Navigator.pop(context);
          }, child: const Text("Save")),
        ],

      );
    },barrierDismissible:false);
  }

  void insertAuditInLocalDb(AuditRequestDataModel auditRequestDataModel) {
    dbHelper.insert(auditRequestDataModel, DatabaseHelper.productDetailsTable).then((value) {
      print("value audit ::$value");
    });
  }
}




