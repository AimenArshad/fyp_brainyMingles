import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/sign_up_student/sign_up_student_view.dart';
import 'package:brainy_mingles/widgets/custom_textfield.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:brainy_mingles/view/sign_up_mentor/sign_up_mentor_two.dart';


class SignUpMentorOne extends StatefulWidget {
  const SignUpMentorOne({super.key});

  @override
  State<SignUpMentorOne> createState() => _SignUpMentorOneState();
}

class _SignUpMentorOneState extends State<SignUpMentorOne> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset("assets/login_top_shape.png"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Text(
                  'Let’s Join',
                  style: TextStyle(
                    color: const Color(0xFF405897),
                    fontSize: 36.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                26.h.sbh,
                CustomTextField(hint: "Name",controller: nameController),
                12.h.sbh,
                CustomTextField(hint: "Username",controller: usernameController),
                12.h.sbh,
                CustomTextField(hint: "Email",controller: emailController),
                12.h.sbh,
                CustomTextField(hint: "Phone No",controller:phoneNumberController),
                12.h.sbh,
                CustomTextField(hint: "Budget",controller:budgetController),
                12.h.sbh,
                CustomTextField(
                  hint: "Password",
                  controller: passwordController,
                  hidePassword: hidePassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: SvgPicture.asset("assets/visibility_password.svg")),
                ),
                12.h.sbh,
                CustomTextField(
                  hint: "Confirm password",
                  hidePassword: hideConfirmPassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                      icon: SvgPicture.asset("assets/visibility_password.svg")),
                ),
                20.h.sbh,
                MyButton(width: 150, textSize: 13.sp,
                  onTap:(){
                      String name = nameController.text;
                      String username = usernameController.text;
                      String email = emailController.text;
                      String phoneNumber = phoneNumberController.text;
                      String password = passwordController.text;
                      String budget = budgetController.text;
                      // Navigate to the second screen and pass collected data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpMentorTwo(
                            name: name,
                            username: username,
                            email: email,
                            phoneNumber: phoneNumber,
                            budget: budget,
                            password: password,
                          ),
                        ),
                      );
                    },
                  text: "Proceed to next"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
