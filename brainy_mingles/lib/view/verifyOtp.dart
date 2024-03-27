import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:brainy_mingles/widgets/custom_otpField.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/home/home_page_view.dart';

Future<void> verifyAndStoreStudent(
    String name,
    String username,
    String email,
    String phoneNumber,
    String password,
    List<Map<String, dynamic>> programmingDomains,
    List<Map<String, dynamic>> programmingLanguages,
    String gender,
    String mode,
    String session,
    String availability,
    int otp) async {
  // const url = 'http://10.0.2.2:4200/api/student/add-student';
  const url = 'http://192.168.10.25:4200/api/student/add-student';

  // Prepare the data to send to the backend
  final data = {
    'name': name,
    'username': username,
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'programmingDomains': programmingDomains,
    'programmingLanguages': programmingLanguages,
    'gender': gender,
    'mode': mode,
    'session': session,
    'availability': availability,
    'otp': otp
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
    // Handle any exceptions
    print('Exception: $error');
  }
}

class InputScreen extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final List<Map<String, dynamic>> programmingDomains;
  final List<Map<String, dynamic>> programmingLanguages;
  final String gender;
  final String mode;
  final String session;
  final String availability;

  const InputScreen({
    Key? key,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.programmingDomains,
    required this.programmingLanguages,
    required this.mode,
    required this.gender,
    required this.session,
    required this.availability,
  }) : super(key: key);
  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController _otpController1 = TextEditingController();
  TextEditingController _otpController2 = TextEditingController();
  TextEditingController _otpController3 = TextEditingController();
  TextEditingController _otpController4 = TextEditingController();

  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;

  @override
  void initState() {
    super.initState();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
  }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  void _onOTPChanged(
      String value, TextEditingController controller, FocusNode nextFocusNode) {
    if (value.isNotEmpty) {
      controller.text = value;
      if (value.length == 1) {
        nextFocusNode.requestFocus();
      }
    }
  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 120.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomOTPField(
                              controller: _otpController1,
                              focusNode: _focusNode2,
                              onChanged: (value) {
                                if (value.length > 1) {
                                  _otpController1.text = value.substring(
                                      0, 1); // Limit to one digit
                                }
                                _onOTPChanged(_otpController1.text,
                                    _otpController1, _focusNode2);
                              },
                            ),
                            SizedBox(width: 10.0),
                            CustomOTPField(
                              controller: _otpController2,
                              focusNode: _focusNode3,
                              onChanged: (value) {
                                if (value.length > 1) {
                                  _otpController2.text = value.substring(
                                      0, 1); // Limit to one digit
                                }
                                _onOTPChanged(_otpController2.text,
                                    _otpController2, _focusNode3);
                              },
                            ),
                            SizedBox(width: 10.0),
                            CustomOTPField(
                              controller: _otpController3,
                              focusNode: _focusNode4,
                              onChanged: (value) {
                                if (value.length > 1) {
                                  _otpController3.text = value.substring(
                                      0, 1); // Limit to one digit
                                }
                                _onOTPChanged(_otpController3.text,
                                    _otpController3, _focusNode4);
                              },
                            ),
                            SizedBox(width: 10.0),
                            CustomOTPField(
                              controller: _otpController4,
                              focusNode:
                                  FocusNode(), // No next focus node as it's the last box
                              onChanged: (value) {
                                if (value.length > 1) {
                                  _otpController4.text = value.substring(
                                      0, 1); // Limit to one digit
                                }
                                _onOTPChanged(_otpController4.text,
                                    _otpController4, FocusNode());
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                15.h.sbh,
                MyButton(
                  onTap: () {
                    int otp = int.tryParse(
                          '${_otpController1.text}${_otpController2.text}${_otpController3.text}${_otpController4.text}',
                        ) ??
                        0;
                    verifyAndStoreStudent(
                      widget.name,
                      widget.username,
                      widget.email,
                      widget.phoneNumber,
                      widget.password,
                      widget.programmingDomains,
                      widget.programmingLanguages,
                      widget.gender,
                      widget.mode,
                      widget.session,
                      widget.availability,
                      otp,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePageView()),
                    );
                  },
                  text: "Continue",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
