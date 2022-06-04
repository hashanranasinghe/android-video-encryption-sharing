import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

class DetailsDialog{
  static builtDetailsDialog(context,vOwner,vName,vEx,vDes,vSize)=> showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(10.0)),
        child: Container(
          height: 350.0,
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
                    Text('Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.sp
                      ),)
                  ],
                ),
              ),
              Padding(
                  padding:  EdgeInsets.all(15.0),
                  child: Text('Video Name: ${vName}${vEx}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.sp
                    ),)),
              Padding(
                padding:  EdgeInsets.all(15.0),
                child: Text('Video Description: ${vDes}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.sp
                  ),),),
              vOwner != null?
              Padding(
                padding:  EdgeInsets.all(15.0),
                child: Text('Video Owner: ${vOwner}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.sp
                  ),),): Container(),
              Padding(
                padding:  EdgeInsets.all(15.0),
                child: Text('Video Size: ${vSize}MB',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.sp
                  ),),),
              Padding(
                padding:  EdgeInsets.only(left: 15,right: 15,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50.w,
                    ),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text('Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEFEF),
                          fontSize: 20.sp
                      ),)),
                  ],
                ),
              ),
            ],


          ),
        ),

      ));
}