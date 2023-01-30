import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsw/drawer/profile_page.dart';
import 'package:jsw/user/login_page.dart';
import '../../service/preferences.dart';
import 'change_password.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white70,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white70),
              accountName: Text(
                "Meghan Patil",
                style: TextStyle(fontSize: 18,color: Colors.black),
              ),
              accountEmail: Text("meghan.p@gmail.com",style: TextStyle(color: Colors.black),),
              currentAccountPictureSize: Size.square(50),
              currentAccountPicture: CircleAvatar(
                //backgroundColor: Color.fromARGB(255, 165, 255, 137),
                backgroundColor: Colors.blue,
                child: Text(
                  "M",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ), //Text
              ), //circleAvatar
            ), //UserAccountDrawerHeader
          ), //DrawerHeader
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text(' Change password '),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ChangePassword()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              await Preferences().removeUser().then((value) {
                if (value == true) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const LoginPage()));
                  //Navigator.of(context).popUntil(ModalRoute.withName('/login'));
                  /*Navigator.of(context).popUntil((route) {
                    print("route.isFirst ${route.isFirst}");
                    return route.isFirst;
                  });*/
                }
              });

            },
          ),
        ],
      ),
    );
  }
}


