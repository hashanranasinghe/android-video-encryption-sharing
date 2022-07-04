import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/screens/loginscreen.dart';
import 'package:app/screens/profilescreen.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:app/screens/videolistscreen.dart';
import 'package:app/widgets/list_tile_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Column(
            children: <Widget>[
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '');
                    Navigator.of(context)
                        .pushReplacementNamed(UploadScreen.routeName);
                  },
                  icon: Icons.home_outlined,
                  text: 'Home'),
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '');
                    Navigator.of(context)
                        .pushReplacementNamed(VideoListScreen.routeName);
                  },
                  icon: Icons.video_collection_outlined,
                  text: 'Video List'),
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '');
                    Navigator.of(context)
                        .pushReplacementNamed(ShareVideoListScreen.routeName);
                  },
                  icon: Icons.video_collection_outlined,
                  text: 'Share Video List'),
              ListTileField(
                  function: () {
                    Provider.of<ShareData>(context, listen: false)
                        .sharingData('', '', '', '');
                    Navigator.of(context)
                        .pushNamed(ContactListScreen.routeName);
                  },
                  icon: Icons.contact_page_outlined,
                  text: 'Contacts'),
              ListTileField(
                  function: () {
                    Navigator.of(context)
                        .pushNamed(FavoriteContactListScreen.routeName);
                  },
                  icon: Icons.favorite_border,
                  text: 'My Contacts'),
              ListTileField(
                  function: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  },
                  icon: Icons.person_outline_rounded,
                  text: 'My Profile'),
              ListTileField(
                  function: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('email');
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  icon: Icons.logout_outlined,
                  text: 'Log Out'),
              Padding(padding: EdgeInsets.only(top: 100)),
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
}
