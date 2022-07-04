import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'loginscreen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = 'Forget-Password-screen';
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Enter your email'),
                    style: const TextStyle(
                      fontFamily: 'InriaSans',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50),
                        primary: kPrimaryColor,
                      ),
                      icon: const Icon(Icons.email),
                      label: Text(
                        'Send email',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'InriaSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        auth.sendPasswordResetEmail(email: _email);
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        Fluttertoast.showToast(
                          msg: "We will send the email for reset the password.",
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ],
      ),
    );
  }
}
