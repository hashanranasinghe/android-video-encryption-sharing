import 'package:app/models/upload_video.dart';
import 'package:app/widgets/videoList/video_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/constants.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);
  static const routeName = 'VideoList screen';

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  List<Object> _videoList = [];
  bool isLoading = true;
  var i;



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUsersVideoList();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopScreenWidget(
                        scaffoldKey: _scaffoldKey,
                        topLeft: SizedBox(
                          height: 50.h,
                          width: 50.w,
                        )),
                    //buildHeader(_videoList.length),
                    //const SizedBox(height: 12),

                    Expanded(
                      child: isLoading == true ?
                      Center(
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          child: const CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),),)
                      : ListView.builder(
                        itemCount: _videoList.length,
                        itemBuilder: (context, index) {
                         print(index);
                         return VideoCard(_videoList[index] as UploadVideo,index);
                        },
                      ),
                    ),

                  ],
                )
                  );
          }

  Future getUsersVideoList() async{
    User? user = _auth.currentUser;
    final uid = user!.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('upload')
        .get();

    setState(() {
      _videoList= List.from(data.docs.map((doc) => UploadVideo.fromMap(doc)));
       isLoading = false;

    });

  }




}
