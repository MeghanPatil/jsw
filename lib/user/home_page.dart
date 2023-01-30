import 'package:flutter/material.dart';
import 'package:jsw/common-methods.dart';
import 'package:jsw/service/api-services.dart';
import 'package:jsw/service/api-urls.dart';
import 'package:provider/provider.dart';
import '../audit/audit_view.dart';
import '../binning/binning_code_data_model.dart';
import '../binning/binning_view.dart';
import '../drawer/drawer_page.dart';
import '../main.dart';
import '../service/db-helper.dart';
import '../service/network_aware_widget.dart';
import '../service/network_status_service.dart';
import '../service/qr-code-scanner.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(title: const Text("Home"),),
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.Online,
       create: (context) => NetworkStatusService().networkStatusController.stream,
        builder: (context, snapshot)  {
          print("snapshot network :: $snapshot");
          NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
          if (networkStatus == NetworkStatus.Online) {
            syncWithDB();
          } else {
            showToast("Offline","");
            /*return Container(
              child: Center(
                child: Text(
                  "No internet connection!",
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0),
                ),
              ),
            );*/
          }
          return GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QRViewExample(callback: (barcode) {
                      print("barcode: ${barcode!.code}");
                    },)));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text("Scan Product"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BinningView()));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text("Binning"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AuditView()));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text("Audit"),
                    ),
                  ),
                ),
              ),
            ],
          );

          return NetworkAwareWidget(
            onlineChild: GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QRViewExample(callback: (barcode) {
                          print("barcode: ${barcode!.code}");
                        },)));
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Text("Scan Product"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BinningView()));
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Text("Binning"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AuditView()));
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Text("Audit"),
                        ),
                      ),
                    ),
                  ),
                ],
            ),
            offlineChild: Container(
              child: Center(
                child: Text(
                  "No internet connection!",
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Future<void> syncWithDB() async {
    print("inside sync with db");
    await dbHelper
        .queryAllRows(DatabaseHelper.binningTable)
        .then((value) async {
      var modelList = await ApiService.createListForBinningProduct(value);
      print('modelList $modelList');
      await ApiService.saveToServerDb(modelList,ApiUrls.saveProductUrl).then((value) {
        print("value after save : ${value}");
      });
    }).whenComplete(() async {
      await dbHelper
          .queryAllRows(DatabaseHelper.productDetailsTable)
          .then((value) async {
        var modelList = await ApiService.createListForAuditProduct(value);
        print('modelList $modelList');
        await ApiService.saveToServerDb(modelList,ApiUrls.saveProductUrl).then((value) {
          print("value after save : ${value}");
        });
      });
    } );
  }
}







///


/*class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Network Aware App"),
      ),
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.Offline,
        create: (context) =>
        NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          onlineChild: Container(
            child: const Center(
              child: Text(
                "I am online",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          offlineChild: Container(
            child: Center(
              child: Text(
                "No internet connection!",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
