import 'dart:io';

import 'package:app/models/firebasefile.dart';
import 'package:app/models/upload_video.dart';
import 'package:app/widgets/video_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../api/firebaseapi.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/topscreen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);
  static const routeName = 'VideoList screen';

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late Future<List<FirebaseFile>> futureFiles;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  List<Object> _videoList = [];
  late final UploadVideo _uploadVideo;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getUsersVideoList();
  }


  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('files/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data!;


                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopScreenWidget(
                        scaffoldKey: _scaffoldKey,
                        topLeft: SizedBox(
                          height: 50,
                          width: 50,
                        )),
                    // buildHeader(files.length),
                    buildHeader(_videoList.length),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        // itemCount: files.length,
                        itemCount: _videoList.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          //final file = _videoList[index];

                          // return buildFile(context, _videoList. );
                          return VideoCard(_videoList[index] as UploadVideo);
                        },
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
  // Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
  //   title: Text(
  //     file.name,
  //     style: TextStyle(
  //       fontWeight: FontWeight.bold,
  //       decoration: TextDecoration.underline,
  //       color: Colors.blue,
  //     ),
  //   ),
  //   trailing: Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       IconButton(onPressed: () async {
  //         Directory d = await getExternalVisibleDir;
  //         //await FirebaseApi.downloadFile(file.ref);
  //         await FirebaseApi.getNormalFile(d,file.url,file.name);
  //
  //         final snackBar = SnackBar(
  //           content: Text('Downloaded ${file.name}'),
  //         );
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       }, icon: const Icon(Icons.download_rounded)),
  //     ],
  //   ),
  // );

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
    title: Text(
      file.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        color: Colors.blue,
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () async {
          Directory d = await getExternalVisibleDir;
          //await FirebaseApi.downloadFile(file.ref);
          // await FirebaseApi.getNormalFile(d,file.url,file.name);

          final snackBar = SnackBar(
            content: Text('Downloaded ${file.name}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }, icon: const Icon(Icons.download_rounded)),
      ],
    ),
  );

  Widget buildHeader(int length) => ListTile(
    tileColor: Colors.blue,
    leading: Container(
      width: 52,
      height: 52,
      child: Icon(
        Icons.file_copy,
        color: Colors.white,
      ),
    ),
    title: Text(
      '$length Files',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );

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
    });
  }


}
