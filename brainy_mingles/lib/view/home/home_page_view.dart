import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/home/home_widgets.dart';
import 'package:brainy_mingles/view/login_view.dart';
import 'package:brainy_mingles/view/sign_up_student/sign_up_options_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
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
              height: 120.h,
              width: 300.w,
              fit: BoxFit.fitWidth,
            ),
            Text(
              'Brainy Mingles',
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            20.h.sbh,
            AuthButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                },
                text: "Login"),
            10.h.sbh,
            AuthButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpOptionsView()));
                },
                text: "Sign up")
          ],
        ),
      ),
    );
  }
}
