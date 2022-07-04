import 'dart:io';
import 'package:app/models/upload_video.dart';
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/widgets/constants.dart';
import 'package:app/widgets/details_dialog.dart';
import 'package:app/widgets/show_custom_snackbar.dart';
import 'package:app/widgets/videoList/card_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../api/firebaseapi.dart';
import '../../models/provider.dart';
import '../../screens/videolistscreen.dart';
import '../dialog_box_three.dart';
import 'package:http/http.dart' as http;

class VideoCard extends StatefulWidget {
  final UploadVideo _uploadVideo;
  final index;

  VideoCard(this._uploadVideo, this.index);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  late AnimationController controller;
  bool isDownloading = false;
  String? size;
  bool isLoading = false;

  @override
  void initState() {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _buildCheckAnimation(context));
    getSize();
    // TODO: implement initState
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        controller.reset();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading != false
        ? CardField(
            textName:
                "${widget._uploadVideo.videoName}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)}",
            downloadFunction: () async {
              downloadVideo(context, widget._uploadVideo.videoUrl,
                      widget._uploadVideo.videoName)
                  .whenComplete(() => _buildDoneAnimation(context));
            },
            shareFunction: () {
              Navigator.of(context)
                  .pushNamed(FavoriteContactListScreen.routeName);
              Provider.of<ShareData>(context, listen: false).sharingData(
                  widget._uploadVideo.videoOwner.toString(),
                  widget._uploadVideo.videoName.toString(),
                  widget._uploadVideo.videoDes.toString(),
                  widget._uploadVideo.videoUrl.toString());

              print(Provider.of<ShareData>(context, listen: false).vName);
              print(widget._uploadVideo.videoUrl);
              print(widget._uploadVideo.videoDes);
            },
            deleteFunction: () {
              DialogBoxThree.dialogBox(
                  "Do you really want to delete ${widget._uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)} ",
                  context, () {
                deleteVideoMe(widget.index, context);
              }, () {
                deleteVideoEvery(widget.index, context);
              });
            },
            detailsFunction: () {
              DetailsDialog.builtDetailsDialog(
                  context,
                  null,
                  widget._uploadVideo.videoName.capitalize,
                  FirebaseApi.getExtension(widget._uploadVideo.videoUrl),
                  widget._uploadVideo.videoDes.capitalize,
                  size);
            },
          )
        : Container();
  }

  void _buildDoneAnimation(context) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250.h,
                    width: 250.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.network(
                            'https://assets10.lottiefiles.com/packages/lf20_u7xpxe36.json',
                            repeat: false,
                            controller: controller, onLoaded: (composition) {
                          controller.forward();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  void _buildDownloadAnimation(context) => showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250.h,
                  width: 250.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.network(
                        'https://assets1.lottiefiles.com/packages/lf20_PLfxP8.json',
                        repeat: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));

  void _builtDetailsDialog(context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 250.0,
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.sp),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Video Name: ${widget._uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.sp),
                      )),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Video Description: ${widget._uploadVideo.videoDes.capitalize}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 50.w,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEFEFEF),
                                  fontSize: 20.sp),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));

  Future downloadVideo(context, url, name) async {
    _buildDownloadAnimation(context);
    Directory d = await getExternalVisibleDir;
    await FirebaseApi.getNormalFile(d, url, name);
    // await Future.delayed(Duration(seconds: 5));
    setState(() {
      isDownloading = true;
    });
    if (isDownloading == true) {
      Navigator.pop(context);
    }
    String msg =
        'Download ${widget._uploadVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._uploadVideo.videoUrl)}';
    CustomSnackBar.showCustomSnackBar(context, msg);
  }

  Future deleteVideoEvery(index, context) async {
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

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("upload")
        .doc(data.docs[index].id)
        .delete()
        .whenComplete(() => Navigator.of(context)
            .pushReplacementNamed(VideoListScreen.routeName));
  }

  Future deleteVideoMe(index, context) async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('upload')
        .get();

    // print(data.docs[index].id);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("upload")
        .doc(data.docs[index].id)
        .delete()
        .whenComplete(() => Navigator.of(context)
            .pushReplacementNamed(VideoListScreen.routeName));
  }

  Future<Directory?> get getAppDir async {
    final appDocDir = await getExternalStorageDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/SecureVideoFolder').exists()) {
      final externalDir = Directory('/storage/emulated/0/SecureVideoFolder');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/SecureVideoFolder')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/SecureVideoFolder');
      return externalDir;
    }
  }

  Future<void> getSize() async {
    http.Response r =
        await http.get(Uri.parse(widget._uploadVideo.videoUrl.toString()));
    var file_size = r.headers["content-length"];
    var s = int.parse(file_size!) / 1000000;
    setState(() {
      size = s.toStringAsFixed(2).toString();
      isLoading = true;
    });
    if (isLoading == true) {
      Navigator.pop(context);
    }
    print(file_size);
    print(s.toStringAsFixed(2));
  }

  void _buildCheckAnimation(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250.h,
                  width: 250.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.network(
                        'https://assets8.lottiefiles.com/packages/lf20_qdf5azlf.json',
                        repeat: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
