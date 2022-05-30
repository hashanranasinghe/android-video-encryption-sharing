import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogBoxThree{
  static dialogBox(text,BuildContext context,Function functionOne,Function functionTwo){
    showCupertinoDialog(
        context: context,
        builder:(context) => CupertinoAlertDialog(
          content: Text(text,
            style: TextStyle(
              fontSize: 20.sp,
            ),),
          actions: [
            CupertinoDialogAction(
              child: Text('No',
                style: TextStyle(
                  fontSize: 20.sp,
                ),),
              onPressed: () {
                Navigator.pop(context);
              },),
            CupertinoDialogAction(
              child: Text('Delete for Me',
                style: TextStyle(
                  fontSize: 20.sp,
                ),),
              onPressed: () async{
                functionOne();
                Navigator.pop(context);
              },),
            CupertinoDialogAction(
              child: Text('Delete for Everyone',
                style: TextStyle(
                  fontSize: 20.sp,
                ),),
              onPressed: () async{
                functionTwo();
                Navigator.pop(context);
              },)
          ],
        ));
  }
}