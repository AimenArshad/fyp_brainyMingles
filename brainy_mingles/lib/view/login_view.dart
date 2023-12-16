import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/widgets/custom_textfield.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brainy_mingles/view/Mentor/main_home_view.dart';
import 'package:brainy_mingles/view/Student/main_home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool hidePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  Future<void> storeStudentId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentId', userId);
  }



  Future<void> performLogin() async {
    // Clear previous validation errors
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validate email and password
    if (email.isEmpty || !isValidEmail(email)) {
      setState(() {
        emailError = "Please enter a valid email address";
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
      return;
    }

    final loginData = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4200/api/login'),
        body: jsonEncode(loginData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        final role = data["role"];
        final token = data["token"];
        final studentId = data["userId"];

        // Store the token
        await storeToken(token);
        await storeStudentId(studentId);
        print(token);
        print(studentId);
        String message;

        // Handle the user's role and set the message
        if (role == "student") {
          message = "Logged in as a Student";
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainHomeViewStudent()));
        } else if (role == "mentor") {
          message = "Logged in as a Mentor";
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainHomeViewMentor()));
        } else if (role == "faculty") {
          message = "Logged in as Faculty";
        } else if (role == "admin") {
          message = "Logged in as an Admin";
        } else {
          message = "Unknown role";
        }

        // Display the message on the screen
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ));
      } else {
        // Handle login error, e.g., show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (error) {
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  bool isValidEmail(String email) {
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset(
            "assets/login_top.png",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(child: SvgPicture.asset("assets/login_illustration.svg")),
          20.h.sbh,
          Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                color: AppColor.blueColor,
                fontSize: 36.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                20.h.sbh,
                CustomTextField(
                  controller: emailController,
                  hint: "Enter your email",
                  //errorText: emailError,
                ),
                20.h.sbh,
                CustomTextField(
                  controller: passwordController,
                  hint: "Enter your password",
                  hidePassword: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: SvgPicture.asset("assets/visibility_password.svg"),
                  ),
                  //  errorText: passwordError,
                ),
                20.h.sbh,
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColor.purpleColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                15.h.sbh,
                MyButton(
                  onTap: performLogin,
                  text: "Login",
                ),
                50.h.sbh,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(
                          color: const Color(0xFF1E232C),
                          fontSize: 15.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Register Now',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 15.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
