import 'package:app/screens/signupscreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:app/widgets/input_field.dart';
import 'package:app/widgets/input_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/Validator.dart';
import '../widgets/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = 'Login screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  String? _email;
  String? _password;
  bool _passwordVisible = false;
  final _form = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                    key: _form,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 200.h,
                                  width: 200.w,
                                  child: Image.asset(
                                    'assets/images/logo2.png',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.r),
                                  child: Text(
                                    "Welcome back!",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontWeight: FontWeight.bold,


                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5,top: 5).r,
                                  child: Text(
                                    "Login to your account",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildEmail(),
                          _buildPassword(),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 40.w),
                            child: TextButton(
                                onPressed: () async{
                                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  sharedPreferences.setString('email', emailController.text);
                                  signIn(emailController.text, passwordController.text);

                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.h, horizontal: 6.w),
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      'SIGN IN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'InriaSans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp),
                                    ),
                                  ),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(27.r),
                                        )),
                                    backgroundColor: MaterialStateProperty.all(
                                        kPrimaryColor))),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //       vertical: 10, horizontal: 10),
                          //   child: Row(
                          //     children: const [
                          //       Expanded(
                          //           child: Divider(
                          //             color: Color(0xff707070),
                          //             thickness: 3,
                          //           )),
                          //       Text(
                          //         '    or sign up with    ',
                          //         style: TextStyle(color: Color(0xff707070)),
                          //       ),
                          //       Expanded(
                          //         child: Divider(
                          //           color: Color(0xff707070),
                          //           thickness: 3,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // SizedBox(
                          //   height: 35,
                          //   child: GestureDetector(
                          //     onTap: (){
                          //
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account ?",
                                style: TextStyle(color: Colors.black,
                                    fontFamily: 'InriaSans',
                                    fontWeight: FontWeight.bold)),
                              TextButton(child: const Text(
                                'Sign up',
                                style: TextStyle(color: kPrimaryColor,
                                    fontFamily: 'InriaSans',
                                    fontWeight: FontWeight.bold)
                              ),
                                onPressed: (){
                                  Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
                                },)
                            ],
                          ),
                        ])),
              ),
            ),
          ],
        ));
  }


  Widget _buildEmail(){
    return InputField(
      controller: emailController,
      icon: Icons.email,
      text: 'User email',
      textAlign: TextAlign.left,
      textInputType: TextInputType.emailAddress,
      function: Validator.emailValidate,

           );
  }

  Widget _buildPassword(){
    return InputPasswordField(
      textEditingController: passwordController,
      text: 'Password',
      function: Validator.passwordValidate,
    );
  }


  Future<void> signIn(String email, String password) async {
    if (_form.currentState!.validate()) {
      print(email);
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successfully"),
        Navigator.of(context)
            .pushReplacementNamed(UploadScreen.routeName),
      })
          .catchError((e) {

        Fluttertoast.showToast(msg: 'Incorrect Email or Password.',
            toastLength: Toast.LENGTH_LONG
        );
      });
    }
  }




}