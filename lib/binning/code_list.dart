import 'package:flutter/material.dart';
import 'package:jsw/main.dart';
import 'package:jsw/binning/binning_code_data_model.dart';
import '../service/db-helper.dart';

class CodeList extends StatefulWidget {
  const CodeList({Key? key}) : super(key: key);

  @override
  State<CodeList> createState() => _CodeListState();
}

class _CodeListState extends State<CodeList> {
  List<CodeDataModel>? codeList;
 List<CodeDataModel>? foundList = [];
  var searchFieldController = TextEditingController();



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await dbHelper.queryAllRows(DatabaseHelper.binningTable).then((value) async {

       var modelList =  await createListFromMap(value);
          codeList = modelList;
          foundList = codeList;
        /*codeList = value;
        foundList = codeList;
        print(foundList);*/
      });
      setState(() {});
    });
  /*  WidgetsBinding.instance.addPostFrameCallback((_) async {
      await codes().then((value) {
        codeList = value;
        foundList = codeList;
      });
      setState(() {});
    });*/
  }


  List<CodeDataModel> createListFromMap(maps){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: searchFieldController,
                onChanged: (val){
                  createSearchTextList(val);
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                        searchFieldController.text = "";
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )),
      body: ListView.builder(
        itemCount: foundList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                    child: Text(index.toString())),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Product",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                          const SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              foundList!.elementAt(index).productCode.toString().toUpperCase(),style: TextStyle(color: Colors.black54),),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Location",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black),),
                          const SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              foundList!.elementAt(index).locationCode.toString().toUpperCase(),style: TextStyle(color: Colors.black54),),
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
          ?.where((code) => code.productCode
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()) || code.locationCode
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
}
