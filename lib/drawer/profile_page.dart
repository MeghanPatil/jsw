import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jsw/service/api-urls.dart';
import '../../common-methods.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,leading: IconButton(onPressed: (){Navigator.pop(context);},icon: const Icon(Icons.keyboard_arrow_left,color: Colors.black,),),),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      InkWell(
                        onTap: (){
                          showImageDetail(context,ApiUrls.profileImage);
                        },
                        child: buildCircleAvatar(),
                      ),
                      Positioned(
                          bottom: 0,
                          right: -25,
                          child: RawMaterialButton(
                            onPressed: () {
                                buildShowGeneralDialog(context, 'Change Profile Image')
                                    .then((value) {
                                  if (value == 'camera') {
                                    getFromCamera().then((value) {
                                      if (value != null) {
                                        setState((){
                                          ApiUrls.profileImage = value.path;
                                        });
                                        //serviceListController.addressProofPhoto.value =value.path;
                                      } else {
                                       // serviceListController.update();
                                      }
                                    });
                                  } else if (value == 'gallery') {
                                    getFromGallery().then((value) {
                                      if (value != null) {
                                        setState((){
                                          ApiUrls.profileImage = value.path!;
                                        });
                                      } else {
                                        //serviceListController.update();
                                      }
                                    });
                                  } else {}
                                });
                            },
                            elevation: 2.0,
                            fillColor: const Color(0xFFF5F6F9),
                            padding: const EdgeInsets.all(15.0),
                            shape: const CircleBorder(),
                            child: const Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                          )),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              label: Text("Employee ID"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Employee ID",
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              label: Text("Employee Name"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Employee Name",
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              label: Text("Employee Contact No"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Employee Contact No",
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              label: Text("Employee Role"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Employee Role",
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              label: Text("Employee Designation"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Employee Designation",
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                   // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size.fromHeight(30), // NEW
                  ),
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCircleAvatar() {
    print("profileImage ${ApiUrls.profileImage}");
    if(ApiUrls.profileImage.contains('assets')){
      return  CircleAvatar(
        backgroundImage: AssetImage(ApiUrls.profileImage),
      );
    }else if(ApiUrls.profileImage.contains('https')){
      return  CircleAvatar(
        backgroundImage: NetworkImage(ApiUrls.profileImage),
      );
    }else{
      return  CircleAvatar(
        backgroundImage: FileImage(File(ApiUrls.profileImage)),
      );
    }

  }
}
