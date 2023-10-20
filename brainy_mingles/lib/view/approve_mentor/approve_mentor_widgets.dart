import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApproveMentorBox extends StatefulWidget {
  const ApproveMentorBox({super.key});

  @override
  State<ApproveMentorBox> createState() => _ApproveMentorBoxState();
}

class _ApproveMentorBoxState extends State<ApproveMentorBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 20.h),
      padding:
          EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w, bottom: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.30,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xE88A8888),
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x14323247),
            blurRadius: 32,
            offset: Offset(0, 24),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                width: 70.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: const DecorationImage(
                        image: AssetImage("assets/profile.jpeg"),
                        fit: BoxFit.cover)),
              ),
              13.w.sbw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mentor',
                    style: TextStyle(
                      color: const Color(0xFF404345),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'CS 2020 FAST Nuces',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Domain',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Interests',
                    style: TextStyle(
                      color: const Color(0xFF3A2F2F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Expertise',
                    style: TextStyle(
                      color: const Color(0xFF3A2F2F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Image.asset(
                "assets/message.png",
                width: 24.w,
                height: 18.h,
                fit: BoxFit.cover,
              )
            ],
          ),
          10.h.sbh,
          Row(
            children: [
              MyButton(
                width: 120.w,
                height: 40.h,
                text: "Accept Request",
                textSize: 10.sp,
              ),
              const Spacer(),
              MyButton(
                width: 120.w,
                height: 40.h,
                text: "Decline Request",
                textSize: 10.sp,
              ),
            ],
          )
        ],
      ),
    );
  }
}
