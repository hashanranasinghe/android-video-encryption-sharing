import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../models/share_video.dart';
import '../widgets/constants.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/videoList/share_video_card.dart';
import '../widgets/topscreen.dart';

class ShareVideoListScreen extends StatefulWidget {
  const ShareVideoListScreen({Key? key}) : super(key: key);
  static const routeName = 'ShareVideoList screen';

  @override
  State<ShareVideoListScreen> createState() => _ShareVideoListScreenState();
}

class _ShareVideoListScreenState extends State<ShareVideoListScreen> {



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  List<Object> _videoList = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      getShareVideoList();
    });

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopScreenWidget(
                        scaffoldKey: _scaffoldKey,
                        topLeft: SizedBox(
                          height: 50.h,
                          width: 50.w,
                        )),
                    // buildHeader(_videoList.length),
                    // const SizedBox(height: 12),
                    Expanded(
                      child: isLoading == true ?
                      Center(
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          child: const CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),),)
                          :_videoList.isNotEmpty? ListView.builder(
                        itemCount: _videoList.length,
                        itemBuilder: (context, index) {
                          return ShareVideoCard(_videoList[index] as ShareVideo,index);
                        },
                      ):Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network('https://assets4.lottiefiles.com/packages/lf20_gzusoplj.json',
                          repeat: true,),
                          SizedBox(
                            height: 100.h,
                          )
                        ],
                      ),
                      ),
                  ],
                ),
    );
  }

  Future getShareVideoList() async{
    User? user = _auth.currentUser;
    final uid = user!.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('share')
        .get();

    setState(() {
      _videoList= List.from(data.docs.map((doc) => ShareVideo.fromMap(doc)));
      isLoading = false;
      print(_videoList.length);
    });
  }
}
