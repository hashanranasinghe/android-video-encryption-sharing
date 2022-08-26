import 'package:app/api/Validator.dart';
import 'package:app/screens/verificationscreen.dart';
import 'package:app/widgets/constants.dart';
import 'package:app/widgets/input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/create_account.dart';
import '../widgets/input_password_field.dart';
import 'loginscreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const routeName = 'Signup screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? _userName;
  String? _email;
  String? _password;
  String? _confirmPassword;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final _form = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                                "Welcome",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'InriaSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 5).r,
                              child: Text(
                                "Create Your Account",
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
                      _buildUsername(),
                      _buildEmail(),
                      _buildPassword(),
                      _buildConfirmPassword(),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 40.w),
                        child: TextButton(
                            onPressed: () {
                              print(usernameController.text);
                              signUp(emailController.text,
                                  passwordController.text);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 6.w),
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'SIGN UP',
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
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor))),
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
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
                      SizedBox(
                        height: 35.h,
                        child: GestureDetector(
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ?",
                            style: TextStyle(
                              fontFamily: 'InriaSans',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontFamily: 'InriaSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                          )
                        ],
                      ),
                    ])),
          ),
        ),
      ],
    ));
  }

  Widget _buildUsername() {
    return InputField(
      textAlign: TextAlign.left,
      controller: usernameController,
      icon: Icons.person,
      text: 'User Name',
      textInputType: TextInputType.name,
      function: Validator.nameValidate,
    );
  }

  Widget _buildEmail() {
    return InputField(
      function: Validator.nameValidate,
      textAlign: TextAlign.left,
      controller: emailController,
      icon: Icons.email,
      text: 'User email',
      textInputType: TextInputType.emailAddress,
    );
  }

  Widget _buildPassword() {
    return InputPasswordField(
      textEditingController: passwordController,
      text: 'Password',
      function: Validator.passwordValidate,
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      child: TextFormField(
        controller: confirmPasswordController,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (confirmPasswordController.text != passwordController.text) {
            return "Password do not match.";
          }
        },
        obscureText: !_passwordVisible,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: kPrimaryColor, width: 3.0.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: kPrimaryColor, width: 3.0.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: kErrorColor, width: 3.0.w),
          ),
          hintStyle: TextStyle(
              fontFamily: 'InriaSans',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          hintText: 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          prefixIcon: Icon(
            Icons.key,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
    );
  }

  void signUp(String email, String password) async {
    if (_form.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFileStore()})
          .catchError((e) {
        Fluttertoast.showToast(
          msg: 'The email address is already taken.',
          toastLength: Toast.LENGTH_LONG,
        );
      });
    }
  }

  postDetailsToFileStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    CreateAccDetails createAccDetails = CreateAccDetails();
    //writing all values
    createAccDetails.userName = usernameController.text;
    createAccDetails.email = user!.email;
    createAccDetails.uid = user.uid;
    firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(createAccDetails.toMap());
    Navigator.of(context)
        .pushReplacementNamed(VerificationEmailScreen.routeName);
  }
}
