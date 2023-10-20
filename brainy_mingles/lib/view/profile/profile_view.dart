import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/profile/profile_widgets.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(
          isPop: true,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                15.h.sbh,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.h,
                      backgroundImage: const AssetImage("assets/profile.jpeg"),
                    ),
                    10.w.sbw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'User',
                          style: TextStyle(
                            color: AppColor.blueColor,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Welcome to BrainyMingles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF1E232C),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 0.10,
                            letterSpacing: 0.14,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                20.h.sbh,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 30.h, bottom: 5.h, left: 30.w),
                  decoration: BoxDecoration(
                      color: const Color(0xff2427600D).withOpacity(.05)),
                  child: const Column(
                    children: [
                      ProfileOptionButton(
                          text: "Edit Profile",
                          iconImage: "assets/profile_icon.svg"),
                      ProfileOptionButton(
                          isAsset: true,
                          text: "Change Password",
                          iconImage: "assets/change_pass.png"),
                      ProfileOptionButton(
                          text: "My interests",
                          iconImage: "assets/profile_icon.svg"),
                      ProfileOptionButton(
                          text: "Notifications",
                          iconImage: "assets/notification_icon.svg"),
                      ProfileOptionButton(
                          text: "Security",
                          iconImage: "assets/security_icon.svg"),
                      ProfileOptionButton(
                          text: "Privacy",
                          iconImage: "assets/privacy_icon.svg"),
                      ProfileOptionButton(
                          text: "Help & Support",
                          iconImage: "assets/help_and_support.svg"),
                      ProfileOptionButton(
                          text: "Report a problem",
                          iconImage: "assets/report_a_problem.svg"),
                      ProfileOptionButton(
                          text: "Terms and Policies",
                          iconImage: "assets/terms_and_condition.svg"),
                      ProfileOptionButton(
                          text: "Logout", iconImage: "assets/logout_icon.svg"),
                    ],
                  ),
                ),
                30.h.sbh
              ],
            ),
          ),
        )
      ],
    );
  }
}
