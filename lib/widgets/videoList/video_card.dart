import 'dart:io';
import 'package:app/models/upload_video.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/widgets/videoList/card_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../api/firebaseapi.dart';
import '../../models/provider.dart';

class VideoCard extends StatelessWidget {
 final UploadVideo _uploadVideo;

 VideoCard(this._uploadVideo);

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

