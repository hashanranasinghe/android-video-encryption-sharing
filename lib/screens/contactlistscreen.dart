import 'package:app/models/favorite_contact.dart';
import 'package:app/models/invitatecontact.dart';
import 'package:app/widgets/constants.dart';
import 'package:app/widgets/contact_list_field.dart';
import 'package:app/widgets/dialog_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

String? finalEmail;

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);
  static const routeName = 'ContactList screen';

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  String? name = '';
  List contact = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getEmail();
  }

  Future getEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? id;
  String? cid;
  final _auth = FirebaseAuth.instance;

  final userCollection = FirebaseFirestore.instance.collection('users');
  String? detailName;
  String? detailEmail;
  bool isDataLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        children: [
          TopScreenWidget(
              scaffoldKey: _scaffoldKey,
              topLeft: SizedBox(
                height: 50.h,
                width: 50.w,
              )),
          SizedBox(
            height: 20.h,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildSearchBar()),
          StreamBuilder(
            stream: (name != '' && name != null)
                ? FirebaseFirestore.instance
                    .collection('users')
                    .where('userName', isGreaterThanOrEqualTo: name)
                    .orderBy("userName", descending: false)
                    .startAt([
                    name,
                  ]).endAt([
                    name! + '\uf8ff',
                  ]).snapshots()
                : FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('userName', descending: false)
                    .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                );
              }
              return Expanded(
                  child: ListView(
                children: snapshot.data!.docs.map((doc) {
                  final dynamic data = doc.data();
                  return Visibility(
                      child: (finalEmail != data['email'])
                          ? ContactListTileField(
                        email: data['email'].toString(),
                              text: data['userName'].toString(),
                              iconData: Icons.add_circle_outline_rounded,
                              function: () {
                                DialogBox.dialogBox(
                                    "Do you really want to send a invitation to ${data['userName'].toString()} ?",
                                    context, () {
                                  print(data['uid'].toString());
                                  print(data['userName'].toString());
                                  print(data['email'].toString());

                                  User? user = _auth.currentUser;
                                  print(user!.uid);
                                  inviteContact(
                                      data['uid'].toString(),
                                      detailName,
                                      detailEmail,
                                      data['userName'].toString(),
                                      data['email'].toString());
                                });
                              })
                          : Container());
                }).toList(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Future getCurrentUser() async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    String userName = documentSnapshot.get('userName');
    String email = documentSnapshot.get('email');
    setState(() {
      detailName = userName;
      detailEmail = email;
      isDataLoading = true;
    });
    print(detailEmail);
    print(detailName);
    return [userName, email];
  }

  Future<String> inviteContact(uid,senderName,senderEmail, contactName, contactEmail) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    InviteContact inviteContact = InviteContact();
    User? user = _auth.currentUser;

    //writing all values
    inviteContact.senderUid=user!.uid;
    inviteContact.senderName = senderName;
    inviteContact.senderEmail= senderEmail;
    inviteContact.inviteContactName = contactName;
    inviteContact.inviteContactEmail = contactEmail;
    inviteContact.uid = uid;

    users.doc(uid).collection('invitations').add(inviteContact.toMap());
    Fluttertoast.showToast(msg: "Sent invitation successfully.");
    return "success";
  }



  Widget _buildSearchBar() {
    return CupertinoSearchTextField(
      prefixInsets: EdgeInsets.only(left: 20.r),
      itemSize: 25,
      autofocus: true,
      onChanged: (value) {
        // Provider.of<Words>(context, listen: false).filterMethod(value);
        setState(() {
          name = value;
          print(name);
        });
      },
      style: TextStyle(fontSize: 20.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: kPrimaryLightColor,
          border: Border.all(width: 2.w, color: kPrimaryColor)),
    );
  }
}
