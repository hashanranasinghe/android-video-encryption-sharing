import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          // DrawerHeader(
          //   child: Container(
          //     width: double.infinity,
          //     decoration: const BoxDecoration(
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/menu.jpg'),
          //           fit: BoxFit.fill,
          //         )),
          //   ),
          // ),
          Column(
            children: <Widget>[
              ListTile(
                onTap: () {

                },
                leading: const Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              // ignore: prefer_const_constructors
              ListTile(
                onTap: () {

                },
                leading: const Icon(
                  Icons.video_collection_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  'Video List',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),

              ListTile(
                onTap: () {

                },
                leading: const Icon(Icons.contact_page_outlined, color: Colors.black),
                title: Text(
                  'Contacts',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),

              ListTile(
                onTap: () {

                },
                leading: const Icon(Icons.face_outlined,
                    color: Colors.black),
                title: Text(
                  'My Profile',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),



              ListTile(
                onTap: () {
                },
                leading: const Icon(Icons.logout_outlined,
                    color: Colors.black),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),

              // Stack(
              //   children: [
              //     Positioned(
              //       child: SizedBox(
              //           height: 150.h,
              //           width: 150.w,
              //           child: Image.asset('assets/images/logo_1.png')),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );;
  }
}
