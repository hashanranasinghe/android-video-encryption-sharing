import 'dart:io';
import 'package:app/models/share_video.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:app/screens/favoritecontactlistscreen.dart';
import 'package:app/screens/sharevideolistscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../api/firebaseapi.dart';
import '../../models/provider.dart';
import '../constants.dart';
import '../details_dialog.dart';
import '../dialog_box.dart';
import '../show_custom_snackbar.dart';
import 'card_field.dart';
import 'package:string_extensions/string_extensions.dart';

class ShareVideoCard extends StatefulWidget {
  final ShareVideo _shareVideo;
  final index;

  ShareVideoCard(this._shareVideo, this.index);

  @override
  State<ShareVideoCard> createState() => _ShareVideoCardState();
}

class _ShareVideoCardState extends State<ShareVideoCard>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  late AnimationController controller;
  bool isLoading = false;
  bool isDownloading = false;
  String? size;

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance
        ?.addPostFrameCallback((_) => _buildCheckAnimation(context));
    getSize();
    checkUrl(context);

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
    return isLoading == true
        ? CardField(
            textName:
                "${widget._shareVideo.videoName}${FirebaseApi.getExtension(widget._shareVideo.videoUrl)}",
            downloadFunction: () async {
              downloadShareVideo(context)
                  .whenComplete(() => _buildDoneAnimation(context));
            },
            shareFunction: () {
              Navigator.of(context)
                  .pushNamed(FavoriteContactListScreen.routeName);
              Provider.of<ShareData>(context, listen: false).sharingData(
                  widget._shareVideo.videoOwner.toString(),
                  widget._shareVideo.videoName.toString(),
                  widget._shareVideo.videoDes.toString(),
                  widget._shareVideo.videoUrl.toString());

              print(Provider.of<ShareData>(context, listen: false).vName);
              print(widget._shareVideo.videoUrl);
              print(widget._shareVideo.videoDes);
            },
            deleteFunction: () {
              DialogBox.dialogBox(
                  "Do you really want to delete ${widget._shareVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._shareVideo.videoUrl)} ",
                  context, () {
                deleteVideo(widget.index, context);
              });
            },
            detailsFunction: () {
              DetailsDialog.builtDetailsDialog(
                  context,
                  widget._shareVideo.videoOwner,
                  widget._shareVideo.videoName.capitalize,
                  FirebaseApi.getExtension(widget._shareVideo.videoUrl),
                  widget._shareVideo.videoDes.capitalize,
                  size);
            },
          )
        : Container();
  }

  Future downloadShareVideo(context) async {
    _buildDownloadAnimation(context);
    Directory d = await getExternalVisibleDir;
    await FirebaseApi.getNormalFile(
        d, widget._shareVideo.videoUrl, widget._shareVideo.videoName);
    setState(() {
      isDownloading = true;
    });
    if (isDownloading == true) {
      Navigator.pop(context);
    }

    String msg =
        'Download ${widget._shareVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._shareVideo.videoUrl)}';
    CustomSnackBar.showCustomSnackBar(context, msg);
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

  Future checkUrl(BuildContext context) async {
    final response =
        await http.get(Uri.parse(widget._shareVideo.videoUrl.toString()));
    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
    } else {
      User? user = _auth.currentUser;
      final uid = user!.uid;

      CollectionReference _collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('share');

      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();

      var vId = querySnapshot.docs[widget.index].reference.id.toString();

      // delete the document

      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('share');
      data.doc(vId).delete();
      String? msg =
          '${widget._shareVideo.videoName.capitalize}${FirebaseApi.getExtension(widget._shareVideo.videoUrl)} is deleted by owner';
      CustomSnackBar.showCustomSnackBar(context, msg);
      Navigator.pop(context);
      print(vId);
    }
    if (isLoading == true) {
      Navigator.pop(context);
    }
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

  Future deleteVideo(index, context) async {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('share')
        .get();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("share")
        .doc(data.docs[index].id)
        .delete()
        .whenComplete(() => Navigator.of(context)
            .pushReplacementNamed(ShareVideoListScreen.routeName));
  }

  void _buildDoneAnimation(context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 250,
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.network(
                          'https://assets10.lottiefiles.com/packages/lf20_u7xpxe36.json',
                          repeat: false,
                          controller: controller, onLoaded: (composition) {
                        controller.forward();
                      }),
                      Text(
                        'Download',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'InriaSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));

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
        await http.get(Uri.parse(widget._shareVideo.videoUrl.toString()));
    var file_size = r.headers["content-length"];
    var s = int.parse(file_size!) / 1000000;

    setState(() {
      size = s.toStringAsFixed(2).toString();
    });
  }
}
