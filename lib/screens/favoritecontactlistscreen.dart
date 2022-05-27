import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import '../models/share_video.dart';
import '../widgets/constants.dart';
import '../widgets/contact_list_field.dart';
import '../widgets/dialog_box.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

class FavoriteContactListScreen extends StatefulWidget {
  const FavoriteContactListScreen({Key? key}) : super(key: key);
  static const routeName = 'FavoriteContactList screen';

  @override
  State<FavoriteContactListScreen> createState() => _FavoriteContactListScreenState();
}

class _FavoriteContactListScreenState extends State<FavoriteContactListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? name = '';
  final _auth = FirebaseAuth.instance;
  String? id;

  Future getData(id) async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot qn =
    await fireStore.collection("LiveProducts").doc(id).collection('contacts').get();
    return qn.docs;
  }


  @override
  Widget build(BuildContext context) {
    User? user =_auth.currentUser;
    final video = Provider.of<ShareData>(context,listen: false);
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
        height: 20,
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildSearchBar()),
            StreamBuilder(
                stream: (name!= ''&& name != null)?

                FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('contacts')
                    .where('contactName',isGreaterThanOrEqualTo:name)
                    .orderBy("contactName",descending: false)
                    .startAt([name,])
                    .endAt([name! + '\uf8ff',])
                    .snapshots()
                    :FirebaseFirestore.instance.collection('users').
                doc(user!.uid).collection('contacts').orderBy('contactName',descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot){
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
                      child: (video.vName== null||video.vName == '')? ListView(
                        children: snapshot.data!.docs.map((doc) {
                          final dynamic data = doc.data();
                          return Visibility(
                              child:
                              ContactListTileField(
                                  text: data['contactName'].toString(),
                                  iconData: Icons.delete,
                                  function: () async {
                                    print(data['uid'].toString());
                                    print(data['contactName'].toString());
                                    print(data['contactEmail'].toString());
                                    User? user = _auth.currentUser;

                                    DocumentReference doc_ref=FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("contacts").doc();


                                    DocumentSnapshot docSnap = await doc_ref.get();
                                    var doc_id2 = docSnap;
                                    print(doc_id2);




                                  })

                          );

                        }).toList(),
                      ):ListView(
                        children: snapshot.data!.docs.map((doc) {
                          final dynamic data = doc.data();
                          return Visibility(
                              child: ContactListTileField(
                                  iconData: Icons.upload_rounded,
                                  text: data['contactName'].toString(),
                                  function: () {
                                    DialogBox.dialogBox(
                                        'Do you really want to share ${video.vName} to ${data['contactName'].toString()}?',
                                        context,
                                            (){
                                          setState(() {
                                            id = data['uid'].toString();
                                          });
                                          print(id);
                                          print(video.vName);


                                          // shareVideo(
                                          //     id,
                                          //     video.vName ,
                                          //     video.vDes,
                                          //     video.vUrl);
                                          // Navigator.of(context).pushNamed(FavoriteContactListScreen.routeName);
                                        });

                                  })

                          );

                        }).toList(),
                      )
                  );
                })


    ]
      )
    );
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
  Future<String> shareVideo(id,videoName,videoDes,urlDownload) async{

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    ShareVideo shareVideo = ShareVideo();

    //writing all values
    shareVideo.videoName = videoName;
    shareVideo.videoDes = videoDes;
    shareVideo.videoUrl = urlDownload;
    shareVideo.uid = id;

    users.doc(id).collection('share').add(shareVideo.toMap());
    Fluttertoast.showToast(msg: "shared successfully.");
    return "success";
  }

}
