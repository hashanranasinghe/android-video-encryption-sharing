import 'dart:io';
import 'package:app/models/share_video.dart';
import 'package:app/screens/contactlistscreen.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../api/firebaseapi.dart';
import '../../models/provider.dart';
import 'card_field.dart';


class ShareVideoCard extends StatelessWidget {
  final ShareVideo _shareVideo;

  ShareVideoCard(this._shareVideo);

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
        });

  }


  Future<Directory?> get getAppDir async{
    final appDocDir = await getExternalStorageDirectory();
    return appDocDir;
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

