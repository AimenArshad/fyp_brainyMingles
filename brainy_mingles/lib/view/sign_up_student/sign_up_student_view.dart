import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/sign_up_student/signup_student_one.dart';
import 'package:brainy_mingles/view/sign_up_student/signup_student_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SignUpStudent extends StatefulWidget {
  const SignUpStudent({super.key});

  @override
  State<SignUpStudent> createState() => _SignUpStudentState();
}

int currentIndex = 0;
late PageController _controller;
bool hidePassword = true;
bool hideConfirmPassword = true;

class _SignUpStudentState extends State<SignUpStudent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              // itemCount: pages.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [SignUpStudentOne(), SignUpStudentTwo(name: 'John Doe',username: 'johndoe', email: 'john@example.com',phoneNumber: '123-456-7890', password: 'secretpassword')],
            ),
          ),
          20.h.sbh,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                List.generate(3, (index) => pageIndicators(index, context)),
          ),
          20.h.sbh,
          Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColor.blueColor),
          )
        ],
      ),
    );
  }

  Container pageIndicators(int index, BuildContext context) {
    return Container(
      height: 10.h,
      width: 10.w,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? AppColor.blueColor
            : AppColor.blueColor.withOpacity(.25),
      ),
    );
  }
}



