import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jsw/adaptive/nav_page.dart';
import 'package:jsw/user/login_page.dart';

import '../service/api-urls.dart';
import '../service/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    getPrefToken();
  }

  getPrefToken()async{
    final String? prefToken = await Preferences().getProfileToken();
    final String? userId = await Preferences().getUserId();
    print("prefToken $prefToken");
    if(prefToken == null){
      Timer(const Duration(seconds: 2), (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginPage()));
      });
    }
    else{
      ApiUrls.profileToken = prefToken;
      ApiUrls.userId = userId??"";
      Timer(const Duration(seconds: 2), (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const AdaptiveNavigationPage()));
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child:Image.asset('assets/logo.png')),
          ],
        ),
      ),
    );
  }
}



/*
How do I properly remove login page from context? (if user press back button then app quits)

When user logout, how do I remove all pages from context and navigate to login page? (already tried but it doesn't work in my case)

c*/
