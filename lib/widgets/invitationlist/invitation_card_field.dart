import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_extensions/string_extensions.dart';

class InvitationCardField extends StatelessWidget {
  final String? textName;
  final Function acceptFunction;
  final Function deleteFunction;

  const InvitationCardField({
    Key? key,
    this.textName,
    required this.acceptFunction,
    required this.deleteFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10).r,
      child: Card(
        elevation: 8,
        shadowColor: kPrimaryLightColor,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30).r,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.r),
                    child: Text(
                      textName.capitalize!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: 20.sp),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            acceptFunction();

                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: kPrimaryColor,
                            size: 50,
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10).r,
                        child: IconButton(
                            onPressed: () {
                              deleteFunction();
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: kPrimaryColor,
                              size: 50,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
