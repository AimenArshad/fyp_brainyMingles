import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/models/student_info.dart';
import 'package:brainy_mingles/widgets/small_button.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/view/mentor_otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendEmail(
  String email
) async {
  const url = 'http://10.0.2.2:4200/api/mentor/sendOtp';

  // Prepare the data to send to the backend
  final data = {
    'email': email,
  };

  final jsonData = jsonEncode(data);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Data sent successfully');
    } else {
     print('Error sending data to the server. Status Code: ${response.statusCode}');
     print('Response Body: ${response.body}');
    }
  } catch (error) {
    print('Exception: $error');
  }
}

class SignUpMentorTwo extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String phoneNumber;
  final String budget;
  final String password;

  const SignUpMentorTwo({
    Key? key,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.budget, 
    required this.password,
    // Add any other variables here
  }): super(key: key);

  @override
  State<SignUpMentorTwo> createState() => _SignUpMentorTwoState();
}

class _SignUpMentorTwoState extends State<SignUpMentorTwo> {
  List<String> expertiseArray = [];
  List<String> languagesArray = [];
  List<String> challengesArray = [];
  List<String> preferencesArray = [];
  String? selectedGender;
  String? selectedMode;
  String? selectedSession;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset("assets/login_top_shape_2.png"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expertise',
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
                  children: StudentModel().domains.map((domain) {
                    return SmallButton(
                      text: domain,
                      isSelected: expertiseArray.contains(domain),
                      onPressed: () {
                        setState(() {
                          if (expertiseArray.contains(domain)) {
                            expertiseArray.remove(domain);
                          } else {
                            expertiseArray.add(domain);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
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
                  children: StudentModel().languages.map((language) {
                    return SmallButton(
                      text: language,
                      isSelected: languagesArray.contains(language),
                      onPressed: () {
                        setState(() {
                          if (languagesArray.contains(language)) {
                            languagesArray.remove(language);
                          } else {
                            languagesArray.add(language);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                Text(
                  'Challenges',
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
                  children: StudentModel().challenges.map((challenge) {
                    return SmallButton(
                      text: challenge,
                      isSelected: challengesArray.contains(challenge),
                      onPressed: () {
                        setState(() {
                          if (challengesArray.contains(challenge)) {
                            challengesArray.remove(challenge);
                          } else {
                            challengesArray.add(challenge);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                Text(
                  'Preferences',
                  style: TextStyle(
                    color: AppColor.blueColor,
                    fontSize: 20.sp,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.h.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 20.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                     Row(
  children: StudentModel().gender.map((gender) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0), // Adjust the right spacing as needed
      child: SmallButton(
        text: gender,
        isSelected: gender == selectedGender,
        onPressed: () {
          setState(() {
            if (gender == selectedGender) {
              selectedGender = null; // Deselect the current selection
              preferencesArray.remove(gender); // Remove deselected gender from preferencesArray
            } else {
              if (selectedGender != null) {
                preferencesArray.remove(selectedGender); // Remove previously selected gender
              }
              selectedGender = gender; // Select the new gender
              preferencesArray.add(gender); // Add selected gender to preferencesArray
            }
          });
        },
      ),
    );
  }).toList(),
),


                      Text(
                        'Mode',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 20.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.h.sbh,
                 Row(
  children: StudentModel().mode.map((mode) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0), // Adjust the right spacing as needed
      child: SmallButton(
        text: mode,
        isSelected: mode == selectedMode,
        onPressed: () {
          setState(() {
            if (mode == selectedMode) {
              selectedMode = null; // Deselect the current selection
              preferencesArray.remove(mode); // Remove deselected gender from preferencesArray
            } else {
              if (selectedMode != null) {
                preferencesArray.remove(selectedMode); // Remove previously selected gender
              }
              selectedMode = mode; // Select the new gender
              preferencesArray.add(mode); // Add selected gender to preferencesArray
            }
          });
        },
      ),
    );
  }).toList(),
),
                      Text(
                        'Sessions',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 20.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.h.sbh,
                     Row(
  children: StudentModel().session.map((session) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0), // Adjust the right spacing as needed
      child: SmallButton(
        text: session,
        isSelected: session == selectedSession,
        onPressed: () {
          setState(() {
            if (session == selectedSession) {
              selectedSession = null; // Deselect the current selection
              preferencesArray.remove(session); // Remove deselected gender from preferencesArray
            } else {
              if (selectedSession != null) {
                preferencesArray.remove(selectedSession); // Remove previously selected gender
              }
              selectedSession = session; // Select the new gender
              preferencesArray.add(session); // Add selected gender to preferencesArray
            }
          });
        },
      ),
    );
  }).toList(),
),
                    ],
                  ),
                ),
                MyButton(
                    onTap:(){
                      String name = widget.name;
                      String username = widget.username;
                      String email = widget.email;
                      String phoneNumber = widget.phoneNumber;
                      String budget = widget.budget;
                      String password = widget.password;
                      sendEmail(email);
                      // Navigate to the second screen and pass collected data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputScreen(
                            name: name,
                            username: username,
                            email: email,
                            phoneNumber: phoneNumber,
                            budget: budget,
                            password: password,
                            domainArray: expertiseArray,
                            languagesArray: languagesArray,
                            challengesArray: challengesArray,
                            preferencesArray: preferencesArray,
                          ),
                        ),
                      );
                    },
                    text: "Register",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
