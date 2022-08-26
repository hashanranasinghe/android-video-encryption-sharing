import 'package:app/models/invitatecontact.dart';
import 'package:app/widgets/invitationlist/invitation_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);
  static const routeName = 'InvitationList screen';

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _auth = FirebaseAuth.instance;
  List<Object> _invitationList = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getInvitationList();
    super.didChangeDependencies();
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
          Expanded(
            child: isLoading == true
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.network(
                          'https://assets8.lottiefiles.com/packages/lf20_qdf5azlf.json',
                          repeat: true,
                        ),
                      ],
                    ),
                  )
                : _invitationList.isNotEmpty
                    ? ListView.builder(
                        itemCount: _invitationList.length,
                        itemBuilder: (context, index) {
                          print(index);
                          return InvitationCard(
                              index, _invitationList[index] as InviteContact);
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network(
                            'https://assets4.lottiefiles.com/packages/lf20_gzusoplj.json',
                            repeat: true,
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
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
  }
}
