import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool hidePassword;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const CustomTextField(
      {super.key,
      required this.hint,
      this.controller,
      this.suffixIcon,
      this.hidePassword = false,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColor.blueColor,
      obscureText: hidePassword,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            color: AppColor.textColor,
            fontSize: 15.sp,
            fontFamily: "Urbanist",
            fontWeight: FontWeight.w500,
            height: 0.08,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide.none),
          fillColor: const Color(0xffF6F6F6),
          filled: true),
    );
  }
}
