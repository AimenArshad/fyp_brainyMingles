import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileOptionButton extends StatelessWidget {
  final String text;
  final String iconImage;
  final bool isAsset;
  final void Function()? onTap;
  const ProfileOptionButton(
      {super.key,
      required this.text,
      required this.iconImage,
      this.onTap,
      this.isAsset = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        margin: EdgeInsets.only(bottom: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
              width: 20.w,
              child: isAsset
                  ? Image.asset(
                      iconImage,
                      fit: BoxFit.fill,
                    )
                  : SvgPicture.asset(
                      iconImage,
                      fit: BoxFit.contain,
                    ),
            ),
            40.w.sbw,
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFF4E4E4E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
