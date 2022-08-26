import 'dart:async';
import 'package:app/screens/uploadscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/local_auth_api.dart';
import 'loginscreen.dart';

String? finalEmail;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routName = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getValidationData().whenComplete(() async {
      Timer(const Duration(seconds: 3), () {
        if (finalEmail == null) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(UploadScreen.routeName);
        }
      });
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/splashthree.png'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 230.w,
                height: 230.h,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
