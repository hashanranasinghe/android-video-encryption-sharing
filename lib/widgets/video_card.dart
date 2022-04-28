import 'dart:io';

import 'package:app/models/upload_video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../api/firebaseapi.dart';

class VideoCard extends StatelessWidget {
 final UploadVideo _uploadVideo;

 VideoCard(this._uploadVideo);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                  child: Text("${_uploadVideo.videoName}"),
                  ),
                  IconButton(onPressed: () async {
                    Directory d = await getExternalVisibleDir;
                    //await FirebaseApi.downloadFile(file.ref);
                    await FirebaseApi.getNormalFile(d,_uploadVideo.videoUrl,_uploadVideo.videoName);

                    final snackBar = SnackBar(
                      content: Text('Downloaded ${_uploadVideo.videoName}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, icon: const Icon(Icons.download_rounded)),

                ],
              ),
            ],
          ),
        ),
      ),
    );
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
