import 'package:app/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputPasswordField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final String? text;
  final Function(String)? function;

  InputPasswordField({Key? key,
    this.textEditingController,
    this.text,
    this.function}) : super(key: key);

  @override
  State<InputPasswordField> createState() => _InputPasswordFieldState();
}

class _InputPasswordFieldState extends State<InputPasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
      return Container(
        child: TextFormField(
          controller: widget.textEditingController,
          textInputAction: TextInputAction.done,
          validator: (value){
            return widget.function!(value!);
          },
          obscureText: !_passwordVisible,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5.r),
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
            hintText: widget.text,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
            prefixIcon: Icon(Icons.key,color: kPrimaryColor,),
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off),
              color: kPrimaryColor,
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
      );

  }
}
