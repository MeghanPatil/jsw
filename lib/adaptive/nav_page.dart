import 'package:flutter/material.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:jsw/user/home_page.dart';

import '../binning/code_list.dart';

class AdaptiveNavigationPage extends StatefulWidget {
  const AdaptiveNavigationPage({Key? key}) : super(key: key);

  @override
  State<AdaptiveNavigationPage> createState() => _AdaptiveNavigationPageState();
}

class _AdaptiveNavigationPageState extends State<AdaptiveNavigationPage> {
  var tabIndex = 0;

  changeIndex(int index) {
    tabIndex = index;
      setState(() {});
  }

  @override
  void initState() {
    super.initState();
   // getUserFromPref();
  }

  /*getUserFromPref() async {
    User userData = await Preferences().getUserDetails();
    ApiUrls.profileToken = userData.profileToken;
  }*/

  final _destination = <AdaptiveScaffoldDestination>[
    const AdaptiveScaffoldDestination(title: "Home", icon: Icons.home),
    const AdaptiveScaffoldDestination(
        title: "Other", icon: Icons.other_houses),
  ];

  bodyView(context){
    return IndexedStack(
      index: tabIndex,
      children: [
        tabIndex==0?  HomePage():Container(),
        tabIndex==1? const Center(child: Text("Other")):Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
      backgroundColor: Colors.blueAccent,
        body: bodyView(context),
        selectedIndex: tabIndex,
        destinations: _destination,
    onDestinationSelected: changeIndex);
  }
}
