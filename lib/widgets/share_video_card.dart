import 'dart:io';

import 'package:app/models/share_video.dart';
import 'package:app/screens/contactlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../api/firebaseapi.dart';


class ShareVideoCard extends StatelessWidget {
  final ShareVideo _shareVideo;

  ShareVideoCard(this._shareVideo);

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
                    child: Text("${_shareVideo.videoName}"),
                  ),
                  IconButton(onPressed: () async {
                    Directory d = await getExternalVisibleDir;
                    //await FirebaseApi.downloadFile(file.ref);
                    await FirebaseApi.getNormalFile(d,_shareVideo.videoUrl,_shareVideo.videoName);

                    final snackBar = SnackBar(
                      content: Text('Downloaded ${_shareVideo.videoName}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, icon: const Icon(Icons.download_rounded)),
                  IconButton(onPressed: (){
                    Navigator.of(context).pushReplacementNamed(ContactListScreen.routeName);
                    // Provider.of<ShareData>(context,listen: false).sharingData(
                    //     _uploadVideo.videoName.toString(),
                    //     _uploadVideo.videoDes.toString(),
                    //     _uploadVideo.videoUrl.toString());

                    // print(Provider.of<ShareData>(context,listen: false).vName);
                    // print(_uploadVideo.videoUrl);
                    // print(_uploadVideo.videoDes);
                  }, icon: const Icon(Icons.share_rounded)),

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

