import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_extensions/string_extensions.dart';

class CardField extends StatelessWidget {
  final String? textName;
  final Function downloadFunction;
  final Function shareFunction;
  final Function deleteFunction;
  final Function detailsFunction;

  const CardField(
      {Key? key,
      this.textName,
      required this.downloadFunction,
      required this.shareFunction,
      required this.deleteFunction,
      required this.detailsFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10).r,
      child: Card(
        elevation: 8,
        shadowColor: kPrimaryLightColor,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.r),
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
                            detailsFunction();
                          },
                          icon: const Icon(
                            Icons.details_rounded,
                            color: kPrimaryColor,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {
                            shareFunction();
                          },
                          icon: const Icon(
                            Icons.share_rounded,
                            color: kPrimaryColor,
                            size: 30,
                          )),
                      IconButton(
                        onPressed: () {
                          downloadFunction();
                        },
                        icon: const Icon(
                          Icons.download_rounded,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteFunction();
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: kPrimaryColor,
                          size: 30,
                        ),
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
