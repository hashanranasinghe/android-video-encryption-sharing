import 'dart:io';
import 'dart:typed_data';
import 'package:app/models/create_account.dart';
import 'package:app/models/upload_video.dart';
import 'package:app/widgets/drawer_widget.dart';
import 'package:app/widgets/topscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/firebaseapi.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);
  static const routeName = 'UploadScreen screen';

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  bool _isGranted = true;
  UploadTask? task;
  File? file;
  Uint8List? bytes;
  String? _videoName;
  String? _description;
  var Result;
  final _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;



  TextEditingController videoNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   final fileName = file!= null ? basename(file!.path) : 'No File Selected';
    requestStoragePermission();
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        children: [
          TopScreenWidget(
              scaffoldKey: _scaffoldKey,
              topLeft: SizedBox(
                height: 50,
                width: 50,
              )),
          Form(
            key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "Upload video",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                  _buildVideoName(),
                  _buildDescription(),
                  TextButton(

                      onPressed: () {
                          selectFile();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'Select video',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              )),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff102248)))),
                  SizedBox(height: 8),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 48),
                  TextButton(
                      onPressed: () {
                              uploadFile();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'Upload',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              )),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff102248)))),
                  SizedBox(height: 20),
                  task != null ? buildUploadStatus(task!) : Container(),

                ],
              )),
        ],
      ),
    );
  }

  //video name
  Widget _buildVideoName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: TextFormField(
        controller: videoNameController,
        autofocus: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            hintText: "Enter the video name",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
        onSaved: (String? value) {
          _videoName = value;
        },
      ),
    );
  }

  //description
  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: TextFormField(
        controller: descriptionController,
        autofocus: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            hintText: "Enter the video description",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30))),

        onSaved: (String? value) {
          _description = value;
        },
      ),
    );
  }

  //requesting storage permission
  requestStoragePermission() async{
    if(!(await Permission.storage.isGranted)){
      PermissionStatus result = await Permission.storage.request();
      if(result.isGranted){
        setState(() {
          _isGranted = true;
        });
      }else{
        _isGranted = false;
      }
    }else if(!(await Permission.accessMediaLocation.isGranted)){
      PermissionStatus result = await Permission.accessMediaLocation.request();
      if(result.isGranted){
        setState(() {
          _isGranted = true;
        });
      }else{
        _isGranted = false;
      }
    }else if(!(await Permission.manageExternalStorage.isGranted)){
      PermissionStatus result = await Permission.manageExternalStorage.request();
      if(result.isGranted){
        setState(() {
          _isGranted = true;
        });
      }else{
        _isGranted = false;
      }
    }
  }

  //selecting video
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    final path = result.files.single.path!;
    setState(() => file = File(path));
    final p = result.files.first.bytes;
    setState(() {
      bytes = p;
    });
  }

  //upload the video
  Future uploadFile() async {


    if (file == null) return;
    final fileName = basename(file!.path);

    final destination = 'files/$fileName.aes';
    await file!.readAsBytes().then(
            (value) => bytes = Uint8List.fromList(value));

    task = FirebaseApi.uploadBytes(destination,bytes!);

    //task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {
            return Fluttertoast.showToast(
              msg: "Complete",
              toastLength: Toast.LENGTH_LONG
            );
          });
    final urlDownload = await snapshot.ref.getDownloadURL();
    CreateAccDetails createAccDetails = CreateAccDetails();





    User? user = _auth.currentUser;
    print(user!.uid);
    await sendVideo(user.uid, urlDownload);

    Fluttertoast.showToast(msg: "uploaded successfully.");


    print('Download-Link: $urlDownload');
  }

  Future<String> sendVideo(id ,urlDownload) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    UploadVideo uploadVideo = UploadVideo();

    //writing all values
    uploadVideo.videoName = videoNameController.text;
    uploadVideo.videoDes = descriptionController.text;
    uploadVideo.videoUrl = urlDownload;
    uploadVideo.uid = id;

    users.doc(id).collection('upload').add(uploadVideo.toMap());
    return "success";
  }

  //uploading percentage it's not work
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(

    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();

      }
    },
  );

}

