import 'package:app/widgets/drawer_widget.dart';
import 'package:app/widgets/topscreen.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _videoName;
  String? _description;
  final _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  TextEditingController videoNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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

                ],
              )),
        ],
      ),
    );
  }
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
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Username can\'t be null';
          }
        },
        onSaved: (String? value) {
          _videoName = value;
        },
      ),
    );
  }


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

}
