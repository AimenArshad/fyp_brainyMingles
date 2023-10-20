import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  final bool isPop;
  final void Function()? onPop;
  const CustomAppBar({super.key, this.isPop = false, this.onPop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      width: double.infinity,
      padding:
          EdgeInsets.only(bottom: 10.h, left: 12.w, right: 12.w, top: 50.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF516CB3), Color(0xBC1F3365)],
        ),
      ),
      child: isPop
          ? Row(
              children: [
                GestureDetector(
                  onTap: onPop ??
                      () {
                        Navigator.pop(context);
                      },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.whiteColor,
                    size: 19.sp,
                  ),
                )
              ],
            )
          : Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SvgPicture.asset(
                    "assets/drop-down.svg",
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
                Spacer(),
                SvgPicture.asset(
                  "assets/notification.svg",
                  height: 20.h,
                  width: 17.w,
                ),
                10.w.sbw,
                CircleAvatar(
                  radius: 20.sp,
                  backgroundImage: AssetImage("assets/profile.png"),
                )
              ],
            ),
    );
  }
}
