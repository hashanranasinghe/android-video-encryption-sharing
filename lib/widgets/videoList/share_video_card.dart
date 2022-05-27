import 'dart:io';
import 'package:app/models/share_video.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/screens/sharevideolistscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../api/firebaseapi.dart';
import '../../models/provider.dart';
import '../dialog_box.dart';
import 'card_field.dart';
import 'package:string_extensions/string_extensions.dart';


class ShareVideoCard extends StatelessWidget {
  final ShareVideo _shareVideo;
  final _auth = FirebaseAuth.instance;
  final index;

  ShareVideoCard(this._shareVideo, this.index);

  @override
  Widget build(BuildContext context) {
    return CardField(
        textName: "${_shareVideo.videoName}${FirebaseApi.getExtension(_shareVideo.videoUrl)}",
        downloadFunction: () async{
          Directory d = await getExternalVisibleDir;
          await FirebaseApi.getNormalFile(d,_shareVideo.videoUrl,_shareVideo.videoName);
          final snackBar = SnackBar(
            content: Text('Downloaded ${_shareVideo.videoName}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        shareFunction:(){
          Navigator.of(context).pushNamed(FavoriteContactListScreen.routeName);
          Provider.of<ShareData>(context,listen: false).sharingData(
              _shareVideo.videoName.toString(),
              _shareVideo.videoDes.toString(),
              _shareVideo.videoUrl.toString());

          print(Provider.of<ShareData>(context,listen: false).vName);
          print(_shareVideo.videoUrl);
          print(_shareVideo.videoDes);
        }, deleteFunction: (){

      DialogBox.dialogBox(
          "Do you really want to delete ${_shareVideo.videoName.capitalize}${FirebaseApi.getExtension(_shareVideo.videoUrl)} "
          , context
          , (){
        deleteVideo(index,context);
      });

    },);

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
        .collection('share')
        .get();

    // print(data.docs[index].id);

    // String Url = _uploadVideo.videoUrl.toString();
    // FirebaseStorage.instance.refFromURL(Url).delete();

    await FirebaseFirestore.instance.collection("users").doc(uid)
        .collection("share").doc(data.docs[index].id)
        .delete().whenComplete(() =>
        Navigator.of(context).pushReplacementNamed(ShareVideoListScreen.routeName));


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

