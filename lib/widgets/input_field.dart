import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String? text;
  final TextInputType textInputType;
  final TextAlign textAlign;
  final Function(String)? function;
  final String? detail;




  const InputField({
    Key? key,
    required this.controller,
    this.icon,
    this.text,
    required this.textInputType,
    required this.textAlign,
    this.function,
    this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        validator: (value){
          return function!(value!);
        },
        textAlign: textAlign,
        decoration: InputDecoration(
          prefixIcon: Icon(icon,color: kPrimaryColor,),
          contentPadding: const EdgeInsets.all(5),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: kPrimaryColor, width: 3.0.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: kPrimaryColor, width: 3.0.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: kErrorColor,width: 3.0.w),
          ),
          hintStyle: TextStyle(
            fontFamily: 'InriaSans',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold
          ),
          hintText: text,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
    );
  }
}
