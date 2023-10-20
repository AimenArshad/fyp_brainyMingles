import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/home/home_widgets.dart';
import 'package:brainy_mingles/view/sign_up_mentor/sign_up_mentor.dart';
import 'package:brainy_mingles/view/sign_up_student/sign_up_student_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpOptionsView extends StatefulWidget {
  const SignUpOptionsView({super.key});

  @override
  State<SignUpOptionsView> createState() => _SignUpOptionsViewState();
}

class _SignUpOptionsViewState extends State<SignUpOptionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.22, -0.97),
            end: Alignment(-0.22, 0.97),
            colors: [Color(0xFF1F3264), Color(0xFF516CB3)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/brainy_mingle_logo.png",
              height: 100.h,
              width: 250.w,
              fit: BoxFit.cover,
            ),
            Text(
              'Sign Up',
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: 36.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            20.h.sbh,
            AuthButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpMentor()));
                },
                text: "As a Mentor"),
            10.h.sbh,
            AuthButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpStudent()));
                },
                text: "As a Student")
          ],
        ),
      ),
    );
  }
}
