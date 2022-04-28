import 'package:app/screens/signupscreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(
                                left: 40, top: 10, bottom: 10),
                            child: Text(
                              "Sign-Up",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                          ),
                          _buildEmail(),
                          _buildPassword(),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 40),
                            child: TextButton(
                                onPressed: () async{
                                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  sharedPreferences.setString('email', emailController.text);
                                  signIn(emailController.text, passwordController.text);

                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 6),
                                  width: double.infinity,
                                  child: const Center(
                                    child: Text(
                                      'SIGN UP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(27),
                                        )),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff102248)))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: const [
                                Expanded(
                                    child: Divider(
                                      color: Color(0xff707070),
                                      thickness: 3,
                                    )),
                                Text(
                                  '    or sign up with    ',
                                  style: TextStyle(color: Color(0xff707070)),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Color(0xff707070),
                                    thickness: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 35,
                            child: GestureDetector(
                              onTap: (){

                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account ?",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,

                                ),),
                              TextButton(child: const Text(
                                'Sign up',
                                // style: TextStyle(color: Color(0xff707070)),
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

  Widget _buildEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            hintText: "Email",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
        validator: (value) {
          return Validator.emailValidate(value!);
        },
        onSaved: (String? value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: TextFormField(
        controller: passwordController,
        obscureText: !_passwordVisible,
        keyboardType: TextInputType.visiblePassword,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            color: Colors.black,
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          return Validator.PasswordValidate(value!);
        },
        onSaved: (String? value) {
          _password = value;
        },
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    if (_form.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
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

class Validator {

  static String? PasswordValidate(String passwordValue) {
    if (passwordValue.isEmpty) {
      return "Password Cannot be Empty";
    } else if (!passwordValue.contains(RegExp(r'[a-zA-Z0-9]'))) {
      return "Invalid Password";
    }else if(passwordValue.length < 6){
      return "Enter valid Password.(Min. 6 characters)";
    }
    return null;
  }

  static String? emailValidate(String emailValue){
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    if (emailValue.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!regExp.hasMatch(emailValue)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }
}

