import 'package:app/screens/profilescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/constants.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = 'Settings screen';
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getSwitchState();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSwitched = false;

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }

  Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("switchState");
    print(isSwitchedFT);
    setState(() {
      isSwitched = isSwitchedFT!;
    });
    return isSwitchedFT;
  }

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
                height: 50,
                width: 50,
              )),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child: SizedBox(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.fingerprint_outlined,
                        color: kPrimaryColor,
                      ),
                      Text(
                        "Finger Print",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                            fontSize: 20),
                      ),
                      Switch(
                        activeColor: kPrimaryColor,
                          value: isSwitched,
                          onChanged: (bool value) {
                            setState(() {
                              isSwitched = value;
                              saveSwitchState(value);
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ProfileScreen.routeName);
              },
              child: Card(
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          color: kPrimaryColor,
                        ),
                        Text(
                          "Update the profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                              fontSize: 20),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: kPrimaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
