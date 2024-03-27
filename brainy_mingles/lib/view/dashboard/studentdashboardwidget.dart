import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentInfoBox extends StatelessWidget {
  final String boxName;
  final String imageAddress;
  final List<String> languages;
  final List<int> levels;

  const StudentInfoBox({
    Key? key,
    required this.boxName,
    required this.imageAddress,
    required this.languages,
    required this.levels,
  }) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        color: const Color(0xFF110000),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                        height:
                            20.h), // Increased space between names and levels
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        languages.length,
                        (index) => Text(
                          languages[index],
                          style: TextStyle(
                            color: const Color(0xFF110000),
                            fontSize: 11.sp,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Inria Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                13.h.sbh,
                SizedBox(width: 80.w), // Added space between columns
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level',
                      style: TextStyle(
                        color: const Color(0xFF110000),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                        height:
                            20.h), // Increased space between names and levels
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        levels.length,
                        (index) => Text(
                          levels[index].toString(),
                          style: TextStyle(
                            color: const Color(0xFF110000),
                            fontSize: 11.sp,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Inria Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                13.h.sbh,
              ],
            ),
          )
        ],
      ),
    );
  }
}
