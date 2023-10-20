import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/sign_up_mentor/sign_up_mentor_one.dart';
import 'package:brainy_mingles/view/sign_up_mentor/sign_up_mentor_two.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpMentor extends StatefulWidget {
  const SignUpMentor({super.key});

  @override
  State<SignUpMentor> createState() => _SignUpMentorState();
}

int currentIndex = 0;
late PageController _controller;
bool hidePassword = true;
bool hideConfirmPassword = true;

class _SignUpMentorState extends State<SignUpMentor> {
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
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const [SignUpMentorOne(), SignUpMentorTwo(name: "John Doe",username: "johndoe",email: "john@example.com",phoneNumber: "123-456-7890",password: "password123",budget: "100.0")],
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
            decoration: const BoxDecoration(color: AppColor.blueColor),
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
