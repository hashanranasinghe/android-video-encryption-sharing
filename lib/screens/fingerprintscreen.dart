import 'package:app/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/local_auth_api.dart';

class FingerprintPage extends StatefulWidget {
  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
  static bool? bio;
}

class _FingerprintPageState extends State<FingerprintPage> {
  @override
  void initState() {
    // TODO: implement initState
    getSwitchState();

    super.initState();
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("switchState");
    print(isSwitchedFT);
    authenticate(context, isSwitchedFT);
    return isSwitchedFT;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              ],
            ),
          ),
        ),
      );

  void authenticate(context, isSwitch) async {
    print("in method ${isSwitch}");
    if (isSwitch == true) {
      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }else{
        SystemNavigator.pop();

      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
  }
}
