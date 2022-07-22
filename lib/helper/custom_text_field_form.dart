import 'package:flutter/material.dart';
import 'package:plendify/helper/helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String title;
  final double radius;
  final bool autoFocus;
 final TextInputType  textInputType;
  const CustomTextField(
      {required this.controller,
      required this.hintText,
      required this.labelText,
      required this.title,
       this.radius = 18,
       this.autoFocus = false,
        this.textInputType =  TextInputType.number,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          // autofocus: true,
          controller: controller,
          keyboardType: textInputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter weight';
            }
            return null;
          },
          decoration: textDecorNoBorder(
            radius: 10,
            labelText: labelText,
            hintColor: Color(0xFFB9B9B9),
            borderColor:Colors.white ,
            fill: Colors.white,
            padding: EdgeInsets.only(left: 10,right: 10),
          ),
        )
      ],
    );
  }
}
