import 'dart:io';
import 'package:app/models/upload_video.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/widgets/constants.dart';
import 'package:app/widgets/dialog_box.dart';
import 'package:app/widgets/videoList/card_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../api/firebaseapi.dart';
import '../../models/provider.dart';
import '../../screens/videolistscreen.dart';
import '../dialog_box_three.dart';

class VideoCard extends StatefulWidget {
 final UploadVideo _uploadVideo;
 final index;

 VideoCard(this._uploadVideo, this.index);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> with TickerProviderStateMixin{
 final _auth = FirebaseAuth.instance;
 late AnimationController controller;
 late AnimationController downloadController;
 bool isDownloading = false;
 var time;
 DownloadTask? task;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
        duration: Duration(seconds: 3),
        vsync: this);
    controller.addStatusListener((status) async{
      if(status == AnimationStatus.completed){
        Navigator.pop(context);
        controller.reset();
      }


    });
    // downloadController = AnimationController(
    //   duration: Duration(seconds: 20),
    //     vsync: this);
    // downloadController.addStatusListener((status) async{
    //   if(status == AnimationStatus.completed){
    //     // Navigator.pop(context);
    //     downloadController.reset();
    //   }
    //
    //
    // });

  }
  @override
  void dispose() {

   controller.dispose();
   // downloadController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardField(
      textName: "${widget._uploadVideo.videoName}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)}",
        downloadFunction: () async{

          task != null ? buildDownload(context,task!) : Container();
              downloadVideo(context,
                  widget._uploadVideo.videoUrl,
                  widget._uploadVideo.videoName).whenComplete(() => _buildDoneAnimation(context));




          // DialogBox.dialogBox(
          //     "Do you really want to download ${widget._uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)}?"
          //     , context
          //     , () {
          //
          //

          //
          // });

        },
        shareFunction:(){
                        Navigator.of(context).pushNamed(FavoriteContactListScreen.routeName);
                        Provider.of<ShareData>(context,listen: false).sharingData(
                            widget._uploadVideo.videoName.toString(),
                            widget._uploadVideo.videoDes.toString(),
                            widget._uploadVideo.videoUrl.toString());

                        print(Provider.of<ShareData>(context,listen: false).vName);
                        print(widget._uploadVideo.videoUrl);
                        print(widget._uploadVideo.videoDes);
        },
      deleteFunction:() {

        DialogBoxThree.dialogBox(
            "Do you really want to delete ${widget._uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)} "
            , context
            , (){
          deleteVideoMe(widget.index,context);
        },
            (){
              deleteVideoEvery(widget.index,context);
            });
    },
        );
  }

  void _buildDoneAnimation(context) { showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) =>Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 250,
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network('https://assets10.lottiefiles.com/packages/lf20_u7xpxe36.json',
                      repeat: false,
                      controller: controller,
                      onLoaded: (composition){
                        controller.forward();

                      }),
                  Text('Download',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: 'InriaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp),
                  ),

                ],
              ),
            ),
          ],
        ),
      ));
 }

 // void _buildDownloadAnimation(context) => showDialog(
 //     barrierDismissible: false,
 //     context: context,
 //     barrierColor: Colors.transparent,
 //
 //     builder: (context) =>Dialog(
 //       elevation: 0,
 //       backgroundColor: Colors.transparent,
 //       child: Column(
 //         mainAxisSize: MainAxisSize.min,
 //         children: [
 //           SizedBox(
 //             height: 250,
 //             width: 200,
 //             child: Column(
 //               mainAxisSize: MainAxisSize.min,
 //               children: [
 //                 Lottie.network('https://assets9.lottiefiles.com/packages/lf20_IQ2L4E/download_from_cloud_05.json',
 //                     repeat: true,
 //                 controller: downloadController,
 //
 //                 onLoaded: (composition){
 //                   downloadController.forward();
 //
 //                 }
 //               ),
 //                 Text('Downloading......',
 //                   style: TextStyle(
 //                       color: kPrimaryColor,
 //                       fontFamily: 'InriaSans',
 //                       fontWeight: FontWeight.bold,
 //                       fontSize: 20.sp),
 //                 ),
 //
 //               ],
 //             ),
 //           ),
 //         ],
 //       ),
 //     ));

 void buildDownload(context,DownloadTask task){showDialog(
     barrierDismissible: false,
     context: context,
     builder: (context) => Dialog(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           task != null ?  buildDownloadStatus(task): Container(),
         ],
       ),

 ));
  Navigator.pop(context);
 }





  Future downloadVideo(context,url,name) async{


    // _buildDownloadAnimation(context);
    Directory d = await getExternalVisibleDir;
    task = await FirebaseApi.getNormalFile(d,url,name);



    // buildDownloadStatus(task!);


    if (task == null) return;



    final snapshot = await task!.whenComplete(() {
      return Fluttertoast.showToast(
          msg: "Complete",
          toastLength: Toast.LENGTH_LONG
      );
    });
    // await Future.delayed(Duration(seconds: 5));

    // final snackBar = SnackBar(
    //   content: Text('Downloaded ${widget._uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)}'),
    // );
    //
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  Widget buildDownloadStatus(DownloadTask task) => StreamBuilder<TaskSnapshot>(

   stream: task.snapshotEvents,
   builder: (context, snapshot) {
     if (snapshot.hasData) {
       final snap = snapshot.data!;
       final progress = snap.bytesTransferred / snap.totalBytes;
       final percentage = (progress * 100).toStringAsFixed(2);
       print(percentage);

       return Text(
         '$percentage %',
         style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
       );
     } else {
       return Container();

     }
   },
 );

 Future<Directory?> get getAppDir async{
   final appDocDir = await getExternalStorageDirectory();
   return appDocDir;
 }

 Future deleteVideoEvery(index,context) async{
   User? user = _auth.currentUser;
   final uid = user!.uid;
   var data = await FirebaseFirestore.instance
       .collection('users')
       .doc(uid)
       .collection('upload')
       .get();

   // print(data.docs[index].id);

   String Url = widget._uploadVideo.videoUrl.toString();
   FirebaseStorage.instance.refFromURL(Url).delete();

   await FirebaseFirestore.instance.collection("users").doc(uid)
       .collection("upload").doc(data.docs[index].id)
       .delete().whenComplete(() =>
       Navigator.of(context).pushReplacementNamed(VideoListScreen.routeName));

 }

 Future deleteVideoMe(index,context) async{
   User? user = _auth.currentUser;
   final uid = user!.uid;
   var data = await FirebaseFirestore.instance
       .collection('users')
       .doc(uid)
       .collection('upload')
       .get();

   // print(data.docs[index].id);

   // String Url = _uploadVideo.videoUrl.toString();
   // FirebaseStorage.instance.refFromURL(Url).delete();

   await FirebaseFirestore.instance.collection("users").doc(uid)
       .collection("upload").doc(data.docs[index].id)
       .delete().whenComplete(() =>
       Navigator.of(context).pushReplacementNamed(VideoListScreen.routeName));

 }

 Future<Directory> get getExternalVisibleDir async{
   if(await Directory('/storage/emulated/0/SecureVideoFolder').exists()){
     final externalDir = Directory('/storage/emulated/0/SecureVideoFolder');
     return externalDir;
   }else{
     await Directory('/storage/emulated/0/SecureVideoFolder')
         .create(recursive: true);
     final externalDir = Directory('/storage/emulated/0/SecureVideoFolder');
     return externalDir;
   }
 }
}

