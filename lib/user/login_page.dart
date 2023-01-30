import 'package:flutter/material.dart';
import 'package:jsw/service/api-urls.dart';
import '../adaptive/nav_page.dart';
import '../common-methods.dart';
import '../service/api-services.dart';
import '../service/preferences.dart';
import 'login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hideText = true;
  bool showText = false;
  final _formKey = GlobalKey<FormState>();


  var empIdController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

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
                        /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
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
                          controller: empIdController,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please enter Employee Id';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              label: Text("Employee ID"),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Contact No. / Employee ID",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: hideText,
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
                              suffixIcon: IconButton(
                                onPressed: _showOrHideText,
                                icon: hideText == false
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: (){}, child: const Text("Forgot Password?")),
                ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        ApiUrls.loaderOnBtn = true;
                      });
                      login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size.fromHeight(30), // NEW
                  ),
                  child: const Text("Sign In"),
                ),
                /*Center(
                  child: TextButton(onPressed: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("New User?"),
                        content:const Text("Please contact system admin") ,
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text("OK")),
                        ],
                      );
                    } ,barrierDismissible: false);
                  }, child: const Text("Register",style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),)),
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("New User?"),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Please contact system admin",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrHideText() {
    setState(() {
      hideText = !hideText;
    });
  }

  Future<void> login() async {
    LoginRequestModel requestModel = LoginRequestModel(
        employeeid: empIdController.text,
        password: passwordController.text);
    print('login req :: ${requestModel.toJson()}');
    await ApiService.postMethod(requestModel.toJson(), ApiUrls.loginUrl)
        .then((value) async {
      print('login res :: ${value}');
      var resData = loginModelFromJson(value);
      if (resData.status == 1) {
        setState(() {
          ApiUrls.loaderOnBtn = false;
        });
        print('on save token :: ${resData.data?.token}');
        await Preferences().saveUserDetails(resData.data!).whenComplete(() async {
          final String? prefToken = await Preferences().getProfileToken();
          print("prefToken save $prefToken");
          ApiUrls.profileToken = prefToken!;
          final String? userId = await Preferences().getUserId();
          print("userId save $userId");
          ApiUrls.userId = userId!;
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const AdaptiveNavigationPage()));
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
