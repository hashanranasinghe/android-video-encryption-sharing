import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogBox {
  static dialogBox(text, BuildContext context, Function function) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              content: Text(
                text,
                style: TextStyle(
                  fontSize: 20.sp,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  onPressed: () async {
                    function();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
