import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brainy_mingles/widgets/custom_drawer.dart';

class ArrangeASessionView extends StatefulWidget {
  final String mentorEmail; // Add this parameter

  const ArrangeASessionView({required this.mentorEmail, Key? key})
      : super(key: key);

  @override
  State<ArrangeASessionView> createState() => _ArrangeASessionViewState();
}

class _ArrangeASessionViewState extends State<ArrangeASessionView> {
  String? authToken;

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _loadAuthToken() async {
    final token = await retrieveToken();
    setState(() {
      authToken = token;
    });
    print("Token: $token");
  }

  String sessionType =
      'Online'; // Default to 'Online', or you can set it to 'Physical'
  String time = '';
  String topic = '';

  Future<void> createSessionRequest() async {
    // Create a session request data object
    final sessions = {
      "sessionType": sessionType,
      "time": time,
      "topic": topic,
    };

    // Create the request data
    final requestData = {
      "mentorEmail": widget.mentorEmail,
      "sessions": [sessions],
    };

    final String? token = await retrieveToken();
    print(token);

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4200/api/student/session-request'),
        body: jsonEncode(requestData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.statusCode == 201
              ? 'Session request created successfully'
              : 'Session request creation failed'),
        ),
      );
    } else {
      // Handle the case where the token is not available
      print('Token not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StudentDrawer(),
      body: Column(
        children: [
          const CustomAppBar(),
          100.h.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                Text(
                  'Arrange a Session',
                  style: TextStyle(
                    color: AppColor.blueColor,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                40.h.sbh,
                InkWell(
                  onTap: () {
                    setState(() {
                      // Toggles the dropdown when clicking the "Session" label
                      sessionType =
                          sessionType == 'Online' ? 'Physical' : 'Online';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55.h,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEEEEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          sessionType,
                          style: TextStyle(
                            color: const Color(0xFF8390A1),
                            fontSize: 15.sp,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                15.h.sbh,
                TextFormField(
                  onChanged: (value) {
                    time = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Available Slots',
                    border: OutlineInputBorder(),
                  ),
                ),
                15.h.sbh,
                TextFormField(
                  onChanged: (value) {
                    topic = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Topic',
                    border: OutlineInputBorder(),
                  ),
                ),
                15.h.sbh,
                MyButton(
                  text:
                      "Request Session", // Notfication should be sent to the mentor of session request.
                  onTap: createSessionRequest,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
