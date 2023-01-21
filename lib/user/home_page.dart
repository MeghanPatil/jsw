import 'package:flutter/material.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

import 'drawer/drawer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Home"),backgroundColor: Colors.blueAccent,elevation: 0,),
      drawer: const DrawerWidget(),
      body: Container(),
      bottomNavigationBar: ResponsiveNavigationBar(
        borderRadius: 2,
      //backgroundGradient: const LinearGradient(colors: [Colors.cyan,Colors.blueAccent]),
      selectedIndex: _selectedIndex,
      padding: const EdgeInsets.all(2),
      onTabChange: changeTab,
        outerPadding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      // showActiveButtonText: false,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      navigationBarButtons: const <NavigationBarButton>[
        NavigationBarButton(
          text: 'Home',
          icon: Icons.home,
          backgroundGradient: LinearGradient(
            colors: [Colors.cyan, Colors.blueAccent],
          ),
        ),
        NavigationBarButton(
          text: 'Code List',
          icon: Icons.list,
          backgroundGradient: LinearGradient(
            colors: [Colors.cyan, Colors.blueAccent],
          ),
        ),
      ],
    ),
    );
  }
}
