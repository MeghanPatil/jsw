import 'package:flutter/cupertino.dart';
import '../service/api-urls.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  final Widget desktop;
  const ResponsiveWidget({Key? key, required this.mobile, required this.tab, required this.desktop}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth <= 680){
        ApiUrls.isMobile = true;
        return mobile;
      }else if(constraints.maxWidth > 680 && constraints.maxWidth <= 1200){
        ApiUrls.isMobile = false;
        return tab;
      }else{
        ApiUrls.isMobile = false;
        return desktop;
      }
    });
  }
}
