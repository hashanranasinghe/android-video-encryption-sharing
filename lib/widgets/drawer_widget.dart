import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/screens/invitationscreen.dart';
import 'package:app/screens/loginscreen.dart';
import 'package:app/screens/profilescreen.dart';
import 'package:app/screens/settingsscreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:app/screens/videolistscreen.dart';
import 'package:app/widgets/list_tile_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invitatecontact.dart';
import '../models/provider.dart';
import '../screens/contactlistscreen.dart';
import '../screens/sharevideolistscreen.dart';

class DrawerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  DrawerWidget({required this.scaffoldKey});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    // TODO: implement initState
    getInvitationList();
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  List<Object> _invitationList = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            children: <Widget>[
              ListTileField(
                function: () {
                  Provider.of<ShareData>(context, listen: false)
                      .sharingData('', '', '', '', '', '');
                  Navigator.of(context)
                      .pushReplacementNamed(UploadScreen.routeName);
                },
                icon: Icons.home_outlined,
                text: 'Home',
                count: "",
              ),
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '', '', '');
                    Navigator.of(context)
                        .pushReplacementNamed(VideoListScreen.routeName);
                  },
                  icon: Icons.video_collection_outlined,
                  count: "",
                  text: 'Video List'),
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '', '', '');
                    Navigator.of(context)
                        .pushReplacementNamed(ShareVideoListScreen.routeName);
                  },
                  icon: Icons.video_collection_outlined,
                  count: "",
                  text: 'Share Video List'),
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '', '', '');
                    Navigator.of(context)
                        .pushNamed(ContactListScreen.routeName);
                  },
                  icon: Icons.contact_page_outlined,
                  count: "",
                  text: 'Users'),
              ListTileField(
                function: () {
                  Navigator.of(context)
                      .pushReplacementNamed(InvitationScreen.routeName);
                },
                icon: Icons.insert_invitation_outlined,
                text: 'Invitations',
                count: _invitationList.length.toString(),
              ),
              ListTileField(
                  function: () {
                    Navigator.of(context)
                        .pushNamed(FavoriteContactListScreen.routeName);
                  },
                  icon: Icons.favorite_border,
                  count: "",
                  text: 'My Contacts'),
              ListTileField(
                  function: () {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                  icon: Icons.settings,
                  count: "",
                  text: 'Settings'),
              ListTileField(
                  function: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('email');
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  icon: Icons.logout_outlined,
                  count: "",
                  text: 'Log Out'),
              Padding(padding: EdgeInsets.only(top: 10.h)),
              Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                        height: 200.h,
                        width: 200.w,
                        child: Image.asset('assets/images/logo2.png')),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future getInvitationList() async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('invitations')
        .get();

    setState(() {
      _invitationList =
          List.from(data.docs.map((doc) => InviteContact.fromMap(doc)));
      isLoading = false;
    });
    print(_invitationList.length);
  }
}
