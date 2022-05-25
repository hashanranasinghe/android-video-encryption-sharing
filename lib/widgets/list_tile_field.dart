import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListTileField extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Function function;

  const ListTileField({Key? key,
    required this.icon,
    required this.text,
    required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: (){
            function();},
          leading: Icon(icon,
              color: kPrimaryColor),
          textColor: kPrimaryColor,
          title: Text(
            text!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}
