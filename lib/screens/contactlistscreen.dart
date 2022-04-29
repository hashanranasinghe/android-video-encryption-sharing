import 'package:app/models/create_account.dart';
import 'package:app/screens/uploadscreen.dart';
import 'package:app/widgets/video_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/provider.dart';
import '../models/share_video.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);
  static const routeName = 'ContactList screen';

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Object> _contactList = [];
  String? id;





  @override
  Widget build(BuildContext context) {

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
                    height: 50,
                    width: 50,
                  )),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),

                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((doc) {
                        final dynamic data = doc.data();
                        return Container(
                            padding: EdgeInsets.all(20),
                            child: GestureDetector(
                              child: Text(data['userName'].toString()),

                              onTap: () {
                                setState(() {
                                  id = data['uid'].toString();
                                });
                                print(id);
                                print(video.vName);
                                shareVideo(id,video.vName , video.vDes, video.vUrl);


                                // shareVideo(id,)
                              },));
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
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
    return "success";
  }

}
