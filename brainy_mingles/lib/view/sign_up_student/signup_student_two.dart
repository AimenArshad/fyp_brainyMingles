import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/models/student_info.dart';
import 'package:brainy_mingles/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:brainy_mingles/view/verifyOtp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendEmail(String email) async {
  final url = 'http://10.0.2.2:4200/api/student/sendOtp';

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
      print(
          'Error sending data to the server. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (error) {
    print('Exception: $error');
  }
}

class SignUpStudentTwo extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;

  const SignUpStudentTwo({
    Key? key,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
  }) : super(key: key);

  @override
  State<SignUpStudentTwo> createState() => _SignUpStudentTwoState();
}

class _SignUpStudentTwoState extends State<SignUpStudentTwo> {
  int value = 0;
  Map<String, int?> expertiseMap = {};
  Map<int, String> expertiseLevelMap = {
    1: 'Low',
    5: 'Medium',
    9: 'High',
  };
  List<String> expertiseArray = [];
  List<String> languagesArray = [];
  String? selectedGender;
  String? selectedMode;
  String? selectedSession;
  String? selectedAvailability;
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
                  'Domain',
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
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showSlider(context, domain, expertiseArray);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              expertiseMap.containsKey(domain)
                                  ? const Color(0xFF405897)
                                  : const Color(0xFFD9D9D9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                domain,
                                style: TextStyle(
                                  color: expertiseMap.containsKey(domain)
                                      ? Colors.white
                                      : const Color(0xFF313131),
                                  fontSize: 10.sp,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (expertiseMap.containsKey(domain))
                                Text(
                                  '${expertiseLevelMap[expertiseMap[domain]]}',
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                    fontSize: 8.sp, // Decrease font size
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
                  'Languages',
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
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showSlider(context, language, languagesArray);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              expertiseMap.containsKey(language)
                                  ? const Color(0xFF405897)
                                  : const Color(0xFFD9D9D9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                language,
                                style: TextStyle(
                                  color: expertiseMap.containsKey(language)
                                      ? Colors.white
                                      : const Color(0xFF313131),
                                  fontSize: 10.sp,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (expertiseMap.containsKey(language))
                                Text(
                                  '${expertiseLevelMap[expertiseMap[language]]}',
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                    fontSize: 8.sp, // Decrease font size
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
                            padding: EdgeInsets.only(
                                right:
                                    10.0), // Adjust the right spacing as needed
                            child: SmallButton(
                              text: gender,
                              isSelected: gender == selectedGender,
                              onPressed: () {
                                setState(() {
                                  if (gender == selectedGender) {
                                    selectedGender =
                                        null; // Deselect the current selection
                                  } else {
                                    selectedGender =
                                        gender; // Select the new gender
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
                            padding: EdgeInsets.only(
                                right:
                                    10.0), // Adjust the right spacing as needed
                            child: SmallButton(
                              text: mode,
                              isSelected: mode == selectedMode,
                              onPressed: () {
                                setState(() {
                                  if (mode == selectedMode) {
                                    selectedMode =
                                        null; // Deselect the current selection
                                  } else {
                                    selectedMode =
                                        mode; // Select the new gender
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
                            padding: EdgeInsets.only(
                                right:
                                    10.0), // Adjust the right spacing as needed
                            child: SmallButton(
                              text: session,
                              isSelected: session == selectedSession,
                              onPressed: () {
                                setState(() {
                                  if (session == selectedSession) {
                                    selectedSession =
                                        null; // Deselect the current selection
                                  } else {
                                    selectedSession =
                                        session; // Select the new gender
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      Text(
                        'Availability',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 20.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.h.sbh,
                      Row(
                        children:
                            StudentModel().availability.map((availability) {
                          return Padding(
                            padding: EdgeInsets.only(
                                right:
                                    10.0), // Adjust the right spacing as needed
                            child: SmallButton(
                              text: availability,
                              isSelected: availability == selectedAvailability,
                              onPressed: () {
                                setState(() {
                                  if (availability == selectedAvailability) {
                                    selectedAvailability =
                                        null; // Deselect the current selection
                                  } else {
                                    selectedAvailability =
                                        availability; // Select the new gender
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
                  width: 150,
                  textSize: 13.sp,
                  onTap: () {
                    String name = widget.name;
                    String username = widget.username;
                    String email = widget.email;
                    String phoneNumber = widget.phoneNumber;
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
                          password: password,
                          programmingDomains: expertiseArray
                              .map((domain) => {
                                    'name': domain,
                                    'difficultyLevel': expertiseMap[domain]
                                  })
                              .toList(),
                          programmingLanguages: languagesArray
                              .map((language) => {
                                    'name': language,
                                    'difficultyLevel': expertiseMap[language]
                                  })
                              .toList(),
                          gender: selectedGender!,
                          mode: selectedMode!,
                          session: selectedSession!,
                          availability: selectedAvailability!,
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

  void _showSlider(
      BuildContext context, String domain, List<String> expertiseArr) {
    int selectedValue =
        expertiseMap.containsKey(domain) ? expertiseMap[domain]! : 1;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select Value for $domain'),
                  Slider(
                    value: selectedValue.toDouble(),
                    min: 1,
                    max: 9,
                    divisions: 2,
                    label: expertiseLevelMap[selectedValue]!,
                    activeColor: AppColor.blueColor,
                    onChanged: (double newvalue) {
                      setState(() {
                        selectedValue = newvalue.toInt();
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        expertiseMap[domain] = selectedValue;
                        if (selectedValue > 0 &&
                            !expertiseArr.contains(domain)) {
                          expertiseArr.add(domain);
                        } else if (selectedValue == 0 &&
                            expertiseArr.contains(domain)) {
                          expertiseArr.remove(domain);
                        }
                      });

                      // Close the bottom sheet and execute the callback
                      Navigator.pop(context, () {
                        setState(() {});
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor
                          .blueColor, // Set the background color of the button
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white, // Set the text color of the button
                        fontSize: 16.sp, // Adjust font size as needed
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
    });
  }
}
