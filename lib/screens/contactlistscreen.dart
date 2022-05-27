import 'package:app/models/favorite_contact.dart';
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




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
  }

  Future getEmail() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });

  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? id;
  String? cid;
  final _auth = FirebaseAuth.instance;






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
                stream: (name!= ''&& name != null)?
                    FirebaseFirestore.instance.collection('users')
                        .where('userName',isGreaterThanOrEqualTo:name)
                        .orderBy("userName",descending: false)
                        .startAt([name,])
                        .endAt([name! + '\uf8ff',])
                        .snapshots()
                :FirebaseFirestore.instance.collection('users').orderBy('userName',descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    child:ListView(
                      children: snapshot.data!.docs.map((doc) {
                        final dynamic data = doc.data();
                          return Visibility(
                            child: (finalEmail != data['email'])?
                            ContactListTileField(
                                text: data['userName'].toString(),
                                iconData: Icons.add_circle_outline_rounded,
                                function: () {
                                  DialogBox.dialogBox(
                                  "Do you really want to add ${data['userName'].toString()} to my contacts?"
                                  , context, (){
                                    print(data['uid'].toString());
                                    print(data['userName'].toString());
                                    print(data['email'].toString());

                                    User? user = _auth.currentUser;
                                    print(user!.uid);
                                    favoriteContact(data['userName'].toString(),
                                        data['email'].toString());
                                  });

                                })
                                :Container()
                          );

                      }).toList(),
                    )
                  );
                },
              ),
            ],
          ),
        );



  }

  Future<String> favoriteContact(contactName,contactEmail) async{

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    FavoriteContact favoriteContact = FavoriteContact();
    User? user = _auth.currentUser;

    //writing all values
    favoriteContact.contactName = contactName;
    favoriteContact.contactEmail = contactEmail;
    favoriteContact.uid = user!.uid;

    users.doc(user.uid).collection('contacts').add(favoriteContact.toMap());
    Fluttertoast.showToast(msg: "Added favorite successfully.");
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
      style: TextStyle(
        fontSize: 20.sp
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: kPrimaryLightColor,
        border: Border.all(width: 2.w,color: kPrimaryColor)
      ),
    );
  }




}
