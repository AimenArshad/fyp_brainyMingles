import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/approve_mentor/approve_mentor_widgets.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApproveMentorView extends StatefulWidget {
  const ApproveMentorView({super.key});

  @override
  State<ApproveMentorView> createState() => _ApproveMentorViewState();
}

class _ApproveMentorViewState extends State<ApproveMentorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                17.h.sbh,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Approve a ',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Mentor',
                        style: TextStyle(
                          color: const Color(0xFFA0A4A8),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          10.h.sbh,
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 10.h),
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const ApproveMentorBox();
                  })),
        ],
      ),
    );
  }
}
