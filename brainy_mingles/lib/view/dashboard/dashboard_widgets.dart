import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardInfoBox extends StatelessWidget {
  final String boxName;
  final String imageAddress;
  final String name;
  final String email;
  final String phoneNo;
  final String degree;
  final String batch;
  final String status;
  const DashboardInfoBox(
      {super.key,
      required this.boxName,
      required this.imageAddress,
      required this.name,
      required this.email,
      required this.phoneNo,
      required this.degree,
      required this.batch,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColor.blueColor.withOpacity(.2)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF516CB3), Color(0xBC1F3365)],
              ),
            ),
            child: Row(
              children: [
                Image.asset(imageAddress),
                10.w.sbw,
                Text(
                  boxName,
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 16.sp,
                    fontFamily: 'Inria Sans',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 35.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableRowText("Name:", name),
                    13.h.sbh,
                    reusableRowText("Email:", email),
                    13.h.sbh,
                    reusableRowText("Phone no:", phoneNo),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reusableRowText("Degree", degree),
                    13.h.sbh,
                    reusableRowText("Batch", batch),
                    13.h.sbh,
                    reusableRowText("Status", status),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Reusable Row Text

Widget reusableRowText(String text, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          color: const Color(0xFF110000),
          fontSize: 11.sp,
          fontFamily: 'Inria Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
      5.w.sbw,
      SizedBox(
        width: 70.w,
        child: Text(
          value,
          maxLines: 1,
          style: TextStyle(
            color: const Color(0xFF110000),
            fontSize: 11.sp,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Inria Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      )
    ],
  );
}
