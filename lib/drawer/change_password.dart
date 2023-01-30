import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common-methods.dart';
import '../../service/api-services.dart';
import '../../service/api-urls.dart';
import 'model/change_password_model.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  var currentPasswordController= TextEditingController();
  var newPasswordController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ApiUrls.loaderOnBtn == true? const Center(child: CircularProgressIndicator()) :Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/logo.png')),
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
                          controller: currentPasswordController,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please enter current password';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              label: Text("Current Password"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Current Password",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: newPasswordController,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              label: const Text("Password"),
                              labelStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        ApiUrls.loaderOnBtn = true;
                      });
                      changePasswordMethod();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size.fromHeight(30), // NEW
                  ),
                  child: const Text("Change Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePasswordMethod() async {
    ChangePasswordRequest requestModel = ChangePasswordRequest(
      id: ApiUrls.userId,
        currentPassword: currentPasswordController.text,
        password: newPasswordController.text);
    print('change pass req :: ${requestModel.toJson()}');
    await ApiService.putMethod(requestModel, ApiUrls.changePasswordUrl)
        .then((value) async {
      print('change password res :: ${value}');
      var resData = changePasswordResponseFromJson(value);
      if (resData.status == 1) {
        setState(() {
          ApiUrls.loaderOnBtn = false;
          showToast(resData.message,"");
        });

      } else {
        setState(() {
          ApiUrls.loaderOnBtn = false;
        });
        showToast(resData.message,"");
      }

    });
  }
}
