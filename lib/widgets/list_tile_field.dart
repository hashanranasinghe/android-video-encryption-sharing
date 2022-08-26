import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListTileField extends StatelessWidget {
  final IconData icon;
  final String? text;
  final String? count;
  final Function function;

  const ListTileField(
      {Key? key,
      required this.icon,
      required this.text,
      this.count,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            function();
          },
          leading: Icon(icon, color: kPrimaryColor),
          textColor: kPrimaryColor,
          title: Text(
            text!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          trailing: count != '' && count != '0'
              ? Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                    ),
                    child: Center(
                      child: Text(
                        count!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ))
              : null,
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}
