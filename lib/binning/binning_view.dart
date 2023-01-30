import 'package:flutter/material.dart';
import 'package:jsw/service/api-services.dart';
import 'package:jsw/service/network_status_service.dart';
import 'package:provider/provider.dart';
import '../common-methods.dart';
import '../main.dart';
import 'binning_code_data_model.dart';
import '../service/api-urls.dart';
import '../service/db-helper.dart';
import '../service/qr-code-scanner.dart';

class BinningView extends StatefulWidget {
  const BinningView({Key? key}) : super(key: key);

  @override
  State<BinningView> createState() => _BinningViewState();
}

class _BinningViewState extends State<BinningView> {
  bool pExistFlg = false;
  List<CodeDataModel>? codeList;
  List<CodeDataModel>? foundList = [];
  var searchFieldController = TextEditingController();

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Binning"),actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.sync))],),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QRViewExample(callback: (barcode) {
                    if(barcode!.code.toString().toLowerCase().startsWith("p") == false){
                      showToast("Invalid QR for product :(","");
                    }else{
                      print("barcode pr:: ${barcode!.code.toString()}");
                      ApiUrls.prodQrCode = barcode!.code.toString();
                      print("ApiUrls.prodQrCode:: ${ApiUrls.prodQrCode}");
                      setState(() {});
                    }
                  })));
                }, child: const Text("Scan Product QR")),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QRViewExample(callback: (barcode) {
                    if(barcode!.code.toString().toLowerCase().startsWith("l") == false){
                      showToast("Invalid QR for location :(","");
                    }else{
                      print("barcode loc:: ${barcode!.code.toString()}");
                      ApiUrls.locQrCode = barcode!.code.toString();
                      print("ApiUrls.locQrCode:: ${ApiUrls.locQrCode}");
                      setState(() {
                      });
                    }
                  })));
                }, child: const Text("Scan Location QR")),
              ],
            ),
            ElevatedButton(
              onPressed: (ApiUrls.prodQrCode == "" || ApiUrls.locQrCode == "") ?  (){
                showToast("Please get both the qr codes before saving","");
              } : () async {
               await insertDataOnLocalDB();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (ApiUrls.prodQrCode == "" || ApiUrls.locQrCode == "") ? Colors.grey : Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size.fromHeight(30), // NEW
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  void initState() {
    super.initState();
    getQRListFromLocalDb();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBinningTab(
        context); /*Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Binning'),
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
      backgroundColor: Colors.white24,
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: _buildBinningTab(context),
      ),
    );*/
  }

  Widget _buildBinningTab(context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Binning'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  /*StreamProvider<NetworkStatus>(
                initialData: NetworkStatus.Online,
                create: (context) => NetworkStatusService().networkStatusController.stream,
              );*/
                  setState(() {
                    ApiUrls.loaderOnBtn = true;
                  });
                  await ApiService.saveToServerDb(codeList ?? [],ApiUrls.saveProductUrl).whenComplete(() =>  setState(() {
                    ApiUrls.loaderOnBtn = false;
                  }));

                  /*NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
                  print("networkStatus :$networkStatus");
                  if (networkStatus == NetworkStatus.Online) {
                    saveToServerDb(codeList ?? []);
                  }else{
                    showToast("can't sync u r offline", "");
                  }*/
                },
                icon: const Icon(Icons.sync))
          ],
          automaticallyImplyLeading: false,
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          toolbarHeight: 30,
          bottom: TabBar(
            isScrollable: false,
            labelColor: Colors.blue.shade900,
            indicatorColor: Colors.blueAccent,
            tabs: const [
              Tab(
                text: "Scanner",
                icon: Icon(Icons.qr_code_scanner),
              ),
              Tab(text: "View List", icon: Icon(Icons.list_alt)),
            ],
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: TabBarView(
              children: <Widget>[
                buildScannerWidget(context),
                buildQrDetailsListWidget(context)
              ],
            ),
          );
        }),
      ),
    );
  }

  void createSearchTextList(String enteredKeyword) {
    List<CodeDataModel>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = codeList;
    } else {
      results = codeList
          ?.where((code) =>
              code.productCode
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              code.locationCode
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    //foundList = results;
    setState(() {
      foundList = results;
    });
  }

  Future<void> insertDataOnLocalDB() async {
    //select query to see the product is exist or not
    //if exist then dont send to insert show popup - is if not then send to insert.

    print("ApiUrls.prodQrCode1 ${ApiUrls.prodQrCode}");
    print("ApiUrls.locQrCode1 ${ApiUrls.locQrCode}");

    await dbHelper
        .queryRowCount(DatabaseHelper.binningTable)
        .then((value) async {
      print("db count $value");
      if (value == 0) {
        await dbHelper
            .insert(
                CodeDataModel(
                    productCode: ApiUrls.prodQrCode,
                    locationCode: ApiUrls.locQrCode,
                    dateTime: DateTime.now().toIso8601String()),
                DatabaseHelper.binningTable)
            .then((value) {
          print("after insert value $value");
          if (value > 0) {
            ApiUrls.prodQrCode = "";
            ApiUrls.locQrCode = "";
            showToast("Done!", "");
            //Navigator.of(context).pop();
          } else {
            ApiUrls.prodQrCode = "";
            ApiUrls.locQrCode = "";
            showToast("insert failed!", "");
          }
        });
      } else {
        await dbHelper
            .queryAllRows(DatabaseHelper.binningTable)
            .then((value) async {
          for (var map in value) {
            if (map.containsKey("productCode") ?? false) {
              print("map[productCode] ====== ${map["productCode"]}");
              print("ApiUrls.prodQrCode ${ApiUrls.prodQrCode}");
              if (map["productCode"] == ApiUrls.prodQrCode) {
                pExistFlg = true;
                showToast(
                    "you have already assign the location for ${ApiUrls.prodQrCode}.",
                    "");
                ApiUrls.prodQrCode = "";
                ApiUrls.locQrCode = "";
                setState(() {});
                break;
              }
            } else {
              showToast('key not found', "");
            }
          }
          print('pExistFlg $pExistFlg');
          if (pExistFlg == false) {
            await dbHelper
                .insert(
                    CodeDataModel(
                        productCode: ApiUrls.prodQrCode,
                        locationCode: ApiUrls.locQrCode,
                        dateTime: DateTime.now().toIso8601String()),
                    DatabaseHelper.binningTable)
                .then((value) {
              print("after insert value $value");
              if (value > 0) {
                ApiUrls.prodQrCode = "";
                ApiUrls.locQrCode = "";
                showToast("Done!", "");
                // Navigator.of(context).pop();
              } else {
                ApiUrls.prodQrCode = "";
                ApiUrls.locQrCode = "";
                showToast("insert failed!", "");
              }
            });
          }
        });
      }
    });
  }

  Widget buildScannerWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            QRViewExample(callback: (barcode) {
                              if (barcode!.code
                                      .toString()
                                      .toLowerCase()
                                      .startsWith("p") ==
                                  false) {
                                showToast("Invalid QR for product :(", "");
                              } else {
                                print(
                                    "barcode pr:: ${barcode!.code.toString()}");
                                ApiUrls.prodQrCode = barcode!.code.toString();
                                print(
                                    "ApiUrls.prodQrCode:: ${ApiUrls.prodQrCode}");
                                setState(() {});
                              }
                            })));
                  },
                  child: const Text("Scan Product QR")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            QRViewExample(callback: (barcode) {
                              if (barcode!.code
                                      .toString()
                                      .toLowerCase()
                                      .startsWith("l") ==
                                  false) {
                                showToast("Invalid QR for location :(", "");
                              } else {
                                print(
                                    "barcode loc:: ${barcode!.code.toString()}");
                                ApiUrls.locQrCode = barcode!.code.toString();
                                print(
                                    "ApiUrls.locQrCode:: ${ApiUrls.locQrCode}");
                                setState(() {});
                              }
                            })));
                  },
                  child: const Text("Scan Location QR")),
            ],
          ),
          ElevatedButton(
            onPressed: (ApiUrls.prodQrCode == "" || ApiUrls.locQrCode == "")
                ? () {
                    showToast("Please get both the qr codes before saving", "");
                  }
                : () async {
                    await insertDataOnLocalDB()
                        .then((value) => getQRListFromLocalDb());
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  (ApiUrls.prodQrCode == "" || ApiUrls.locQrCode == "")
                      ? Colors.grey
                      : Colors.lightBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size.fromHeight(30), // NEW
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget buildQrDetailsListWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: searchFieldController,
              onChanged: (val) {
                createSearchTextList(val);
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      /* Clear the search field */
                      searchFieldController.text = "";
                      createSearchTextList("");
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
        Flexible(child: createQRListview(context))
      ],
    );
  }

  Widget createQRListview(context) {
    return ApiUrls.loaderOnBtn == true
        ? const CircularProgressIndicator()
        : (foundList != null && foundList!.isNotEmpty)
            ? RefreshIndicator(
                onRefresh: () => getQRListFromLocalDb(),
                child: ListView.builder(
                  //physics: const NeverScrollableScrollPhysics(),
                  itemCount: foundList?.length ?? 0,
                  itemBuilder: (context, int index) {
                    return Card(
                      elevation: 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(child: Text(index.toString())),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Product",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        foundList!
                                            .elementAt(index)
                                            .productCode
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Location",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        foundList!
                                            .elementAt(index)
                                            .locationCode
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                /*ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          leading: CircleAvatar(
                              child: Text(foundList!.elementAt(index).id.toString())),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Product",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                              Flexible(
                                child: Text(
                                  foundList!.elementAt(index).productCode.toString(),style: TextStyle(color: Colors.black54),),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text("Location",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),),
                                Flexible(
                                  child: Text(
                                    foundList!.elementAt(index).locationCode.toString(),style: TextStyle(),),
                                ),
                              ],
                            ),
                          ),
                        ),*/
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ))
            : const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 18),
                ),
              );
  }

  getQRListFromLocalDb() async {
    await dbHelper
        .queryAllRows(DatabaseHelper.binningTable)
        .then((value) async {
      var modelList = await createListFromMap(value);
      codeList = modelList;
      foundList = codeList;
      print('foundList $foundList');
    });
    setState(() {});
  }

  List<CodeDataModel> createListFromMap(maps) {
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


}
