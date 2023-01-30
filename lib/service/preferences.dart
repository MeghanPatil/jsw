import 'package:jsw/user/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences{

  Future<bool> saveUserDetails(Data user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profileToken", user.token??"");
    prefs.setString("userId", user.id??"");
    return true;
  }


  Future<bool> removeUser()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('profileToken');
    preferences.clear();
    return true;
  }

  Future<String?> getProfileToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? profileToken = preferences.getString("profileToken");
    return profileToken;
  }

  Future<String?> getUserId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString("userId");
    return userId;
  }
}