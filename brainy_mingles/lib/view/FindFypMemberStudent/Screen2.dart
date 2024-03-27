import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/models/fyp_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterFyp extends StatefulWidget {
  final String? cgpa;
  final String? department;
  final String? idea;

  const RegisterFyp({
    Key? key,
    required this.cgpa,
    required this.department,
    required this.idea,
  }) : super(key: key);

  @override
  State<RegisterFyp> createState() => _RegisterFypState();
}

class _RegisterFypState extends State<RegisterFyp> {
  List<String> skillsArray = [];
  List<String> requirementsArray = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              "assets/login_top_shape_2.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skills',
                  style: TextStyle(
                    color: AppColor.blueColor,
                    fontSize: 20.sp,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.h.sbh,
                Wrap(
                  spacing: 10.w,
                  children: FypModel().skills.map((skill) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (skillsArray.contains(skill)) {
                                skillsArray.remove(skill);
                              } else {
                                skillsArray.add(skill);
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              return skillsArray.contains(skill)
                                  ? AppColor.blueColor
                                  : const Color(0xFFD9D9D9);
                            }),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                skill,
                                style: TextStyle(
                                  color: skillsArray.contains(skill)
                                      ? Colors.white
                                      : const Color(0xFF313131),
                                  fontSize: 10.sp,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Text(
                  'Requirements',
                  style: TextStyle(
                    color: AppColor.blueColor,
                    fontSize: 20.sp,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.h.sbh,
                Wrap(
                  spacing: 10.w,
                  children: FypModel().requirements.map((requirement) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (requirementsArray.contains(requirement)) {
                                requirementsArray.remove(requirement);
                              } else {
                                requirementsArray.add(requirement);
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              return requirementsArray.contains(requirement)
                                  ? AppColor.blueColor
                                  : const Color(0xFFD9D9D9);
                            }),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                requirement,
                                style: TextStyle(
                                  color: requirementsArray.contains(requirement)
                                      ? Colors.white
                                      : const Color(0xFF313131),
                                  fontSize: 10.sp,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                  child: Center(
                    child: MyButton(
                      width: 150,
                      textSize: 13.sp,
                      text: "Register",
                      onTap: registerFyp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void registerFyp() async {
    Future<String?> retrieveToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }

    // Prepare the data to be sent in the request body
    Map<String, dynamic> requestBody = {
      'cgpa': widget.cgpa,
      'department': widget.department,
      'idea': widget.idea,
      'skills': skillsArray,
      'requirements': requirementsArray,
    };

    // Convert the request body to JSON format
    String jsonBody = jsonEncode(requestBody);
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      try {
        // Make the API call
        final response = await http.post(
          // Uri.parse('http://10.0.2.2:4200/api/student/fypstudent'),
          Uri.parse('http://192.168.10.25:4200/api/student/fypstudent'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonBody,
        );

        if (response.statusCode == 201) {
          // Handle success
          print('FYP registration successful');
        } else {
          // Handle error
          print('Error: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
      }
    } else {
      // Handle the case where the token is not available
      print('Token not available');
    }
  }
}
