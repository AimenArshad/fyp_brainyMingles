import 'package:brainy_mingles/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double? textSize;
  final double width;
  final double? height;
  final void Function()? onTap;
  const MyButton(
      {super.key,
      required this.text,
      this.onTap,
      this.width = double.infinity,
      this.textSize,
      this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height ?? 55.h,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.30, 0.95),
            end: Alignment(-0.3, -0.95),
            colors: [Color(0xFF546590), AppColor.blueColor],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize ?? 15.sp,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        )),
      ),
    );
  }
}
