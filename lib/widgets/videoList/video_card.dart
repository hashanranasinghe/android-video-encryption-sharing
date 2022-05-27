import 'dart:io';
import 'package:app/models/upload_video.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/widgets/dialog_box.dart';
import 'package:app/widgets/videoList/card_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../api/firebaseapi.dart';
import '../../models/provider.dart';
import '../../screens/videolistscreen.dart';

class VideoCard extends StatelessWidget {
 final UploadVideo _uploadVideo;
 final index;
 final _auth = FirebaseAuth.instance;


 VideoCard(this._uploadVideo, this.index);


  @override
  Widget build(BuildContext context) {
    return CardField(
      textName: "${_uploadVideo.videoName}${FirebaseApi.getExtension(_uploadVideo.videoUrl)}",
        downloadFunction: () async{
                        Directory d = await getExternalVisibleDir;
                        await FirebaseApi.getNormalFile(d,_uploadVideo.videoUrl,_uploadVideo.videoName);
                        final snackBar = SnackBar(
                          content: Text('Downloaded ${_uploadVideo.videoName}'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        shareFunction:(){
                        Navigator.of(context).pushNamed(FavoriteContactListScreen.routeName);
                        Provider.of<ShareData>(context,listen: false).sharingData(
                            _uploadVideo.videoName.toString(),
                            _uploadVideo.videoDes.toString(),
                            _uploadVideo.videoUrl.toString());

                        print(Provider.of<ShareData>(context,listen: false).vName);
                        print(_uploadVideo.videoUrl);
                        print(_uploadVideo.videoDes);
        },
      deleteFunction:() {

        DialogBox.dialogBox(
            "Do you really want to delete ${_uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(_uploadVideo.videoUrl)} "
            , context
            , (){
          deleteVideo(index,context);
        });



    },

        );
  }


 Future<Directory?> get getAppDir async{
   final appDocDir = await getExternalStorageDirectory();
   return appDocDir;
 }

 Future deleteVideo(index,context) async{
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

