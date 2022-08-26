import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_extensions/string_extensions.dart';

class ContactListTileField extends StatelessWidget {
  final String? text;
  final String? email;
  final Function function;
  final IconData iconData;

  const ContactListTileField(
      {Key? key,
      required this.text,
      required this.function,
      required this.iconData, this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (text != 'null')
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ListTile(
                    onTap: () {
                      function();
                    },
                    textColor: kPrimaryColor,
                    title: Text(
                      text.capitalize!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    subtitle: Text(
                     email!,
                      style: TextStyle(

                        fontSize: 15.sp,
                      ),
                    ),
                    trailing: Icon(
                      iconData,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: const Divider(
                    thickness: 2,
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
