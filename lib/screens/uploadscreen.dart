import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/api/Validator.dart';
import 'package:app/models/upload_video.dart';
import 'package:app/widgets/drawer_widget.dart';
import 'package:app/widgets/topscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/firebaseapi.dart';
import '../widgets/constants.dart';
import '../widgets/input_field.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen() : super();
  static const routeName = 'UploadScreen screen';

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isGranted = true;
  UploadTask? task;
  File? file;
  Uint8List? bytes;
  var Result;
  final _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  String? fileName;
  String? error;
  bool isUploading = false;
  final userCollection = FirebaseFirestore.instance.collection('users');
  String? detailName;
  String? detailEmail;
  String? plainText;
  String? encKey;
  String? decKey;
  String? size;

  TextEditingController videoNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      fileName = file != null ? basename(file!.path) : 'No File Selected';
    });

    requestStoragePermission();
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopScreenWidget(
                scaffoldKey: _scaffoldKey,
                topLeft: SizedBox(
                  height: 50.h,
                  width: 50.w,
                )),
            Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Upload video",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'InriaSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 40.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _buildVideoName(),
                    _buildDescription(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
                      child: TextButton(
                          onPressed: () {
                            selectFile();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 6.w),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Select video',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'InriaSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.sp),
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27.r),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(kPrimaryColor))),
                    ),
                    SizedBox(height: 8.h),
                    error != null
                        ? Text(
                            error!,
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'InriaSans',
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp),
                          )
                        : Container(),
                    Text(
                      fileName!,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontFamily: 'InriaSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp),
                    ),
                    SizedBox(height: 48.h),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              plainText = generateRandomString(16);
                              Encryption.plainText = plainText;
                            });
                            encryptKey();
                            uploadFile(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 6.w),
                            width: double.infinity,
                            child: Center(
                              child: isUploading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 24.w),
                                        Text(
                                          'Please wait...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'InriaSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.sp),
                                        )
                                      ],
                                    )
                                  : Text(
                                      'Upload',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'InriaSans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp),
                                    ),
                            ),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27.r),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(kPrimaryColor))),
                    ),
                    task != null ? buildUploadStatus(task!) : Container(),
                    SizedBox(
                      height: 250.h,
                      width: 250.w,
                      child: Image.asset(
                        'assets/images/img.png',
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  //video name
  Widget _buildVideoName() {
    return InputField(
      textAlign: TextAlign.center,
      icon: Icons.video_collection_rounded,
      controller: videoNameController,
      text: 'Video Name',
      textInputType: TextInputType.emailAddress,
      function: Validator.videoValidate,
    );
  }

  //description
  Widget _buildDescription() {
    return InputField(
      textAlign: TextAlign.center,
      icon: Icons.description_rounded,
      controller: descriptionController,
      text: 'Video Description',
      function: Validator.videoValidate,
      textInputType: TextInputType.text,
    );
  }

  //requesting storage permission
  requestStoragePermission() async {
    if (!(await Permission.storage.isGranted)) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
        _isGranted = false;
      }
    } else if (!(await Permission.accessMediaLocation.isGranted)) {
      PermissionStatus result = await Permission.accessMediaLocation.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
        _isGranted = false;
      }
    } else if (!(await Permission.manageExternalStorage.isGranted)) {
      PermissionStatus result =
          await Permission.manageExternalStorage.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
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
    int? sizeInBytes = file?.lengthSync();
    double sizeInMb = sizeInBytes! / 1000000;
    print(sizeInMb.toStringAsFixed(2));
    final p = result.files.first.bytes;
    setState(() {
      bytes = p;
      size = sizeInMb.toStringAsFixed(2);
    });
  }

  //upload the video
  Future uploadFile(context) async {
    if (_form.currentState!.validate()) {
      if (fileName == 'No File Selected') {
        setState(() {
          error = 'Please select the video.';
        });
      } else {
        if (isUploading) return;
        setState(() {
          isUploading = true;
        });
        if (file == null) return;
        final fileName = basename(file!.path);

        final destination = 'files/$fileName.aes';
        await file!
            .readAsBytes()
            .then((value) => bytes = Uint8List.fromList(value));

        task = FirebaseApi.uploadBytes(destination, bytes!);

        //task = FirebaseApi.uploadFile(destination, file!);

        if (task == null) return;

        final snapshot = await task!.whenComplete(() {
          return Fluttertoast.showToast(
              msg: "Complete", toastLength: Toast.LENGTH_LONG);
        });
        final urlDownload = await snapshot.ref.getDownloadURL();

        User? user = _auth.currentUser;
        print(user!.uid);
        await sendVideo(user.uid, urlDownload);
        print('Download-Link: $urlDownload');
        // await Future.delayed(Duration(seconds: 5));
        setState(() {
          isUploading = false;
        });
        Fluttertoast.showToast(msg: "uploaded successfully.").whenComplete(() =>
            Navigator.of(context).pushReplacementNamed(UploadScreen.routeName));
      }
    }
  }

  Future<String> sendVideo(id, urlDownload) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');
    UploadVideo uploadVideo = UploadVideo();

    //writing all values
    uploadVideo.videoSize = size;
    uploadVideo.videoKey = encKey;
    uploadVideo.videoOwner = detailName;
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
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  Future getCurrentUser() async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    String userName = documentSnapshot.get('userName');
    String email = documentSnapshot.get('email');
    setState(() {
      detailName = userName;
      detailEmail = email;
    });
    return [userName, email];
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  String encryptKey() {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText!, iv: iv);
    setState(() {
      encKey = encrypted.base64;
    });
    final decrypted =
        encrypter.decrypt(enc.Encrypted.fromBase64(encKey!), iv: iv);
    setState(() {
      decKey = decrypted;
    });
    return encrypted.base64;
  }
}
