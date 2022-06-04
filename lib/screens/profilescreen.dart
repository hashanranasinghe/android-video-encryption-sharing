import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/Validator.dart';
import '../widgets/constants.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/input_field.dart';
import '../widgets/topscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = 'Profile screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final userCollection = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? detailName;
  String? detailEmail;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopScreenWidget(
              scaffoldKey: _scaffoldKey,
              topLeft: SizedBox(
                height: 50.h,
                width: 50.w,
              )),
            isLoading == true?Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 160.h,
                ),
                Text('My Profile',style:
                TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20.sp,
                    fontFamily: 'InriaSans',
                    fontWeight: FontWeight.bold
                ),),
                SizedBox(
                  height: 20.h,
                ),
                _buildName(),
                _buildEmail(),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextButton(
                      onPressed: () async{
                        updateUserInfo(nameController.text, emailController.text);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 6.w),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Update',
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
              ],
            ):Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.h,
                    ),
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ],
                ))

        ],
      ),
    );
  }

  Widget _buildName(){
    return InputField(
      controller: nameController..text= detailName!,
      icon: Icons.person,
      text: 'User Name',
      detail: detailName,
      textAlign: TextAlign.left,
      textInputType: TextInputType.name,
      function: Validator.nameValidate,

    );
  }
  Widget _buildEmail(){
    return InputField(
      controller: emailController..text=detailEmail!,
      icon: Icons.email,
      text: 'User email',
      detail: detailEmail,
      textAlign: TextAlign.left,
      textInputType: TextInputType.emailAddress,
      function: Validator.emailValidate,

    );
  }



  Future getCurrentUser() async{
    User? user = _auth.currentUser;
    final uid = user!.uid;
    DocumentSnapshot documentSnapshot =await userCollection.doc(uid).get();
    String userName = documentSnapshot.get('userName');
    String email = documentSnapshot.get('email');
    setState(() {
      detailName = userName;
      detailEmail = email;
      isLoading = true;

    });
    print(detailEmail);
    print(detailName);
    return [userName , email];
  }

  Future updateUserInfo(String name,String email ) async{
    User? user = _auth.currentUser;
    final uid = user!.uid;
    return await userCollection.doc(uid).set({
      'userName': name,
      'email': email,
    }
    ).whenComplete(() =>

        Fluttertoast.showToast(msg: "uploaded successfully.").whenComplete(() =>
            Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName)));

  }
}
