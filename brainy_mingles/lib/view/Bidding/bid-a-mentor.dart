import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainy_mingles/models/bidding_courses.dart'; // Import the BiddingCourses class

class BiddingRequestView extends StatefulWidget {
  final String mentorEmail;

  const BiddingRequestView({required this.mentorEmail, Key? key})
      : super(key: key);

  @override
  State<BiddingRequestView> createState() => _BiddingRequestViewState();
}

class _BiddingRequestViewState extends State<BiddingRequestView> {
  String? authToken;
  String sessionType = 'Online';
  String budget = '';
  String selectedCourse = BiddingCourses.courses[0];

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

  Future<void> createBiddingRequest() async {
    // final bids = {
    //   "budget": budget,
    //   "sessionType": sessionType,
    //   "course": selectedCourse,
    // };

    final requestData = {
      "mentorEmail": widget.mentorEmail,
      "budget": budget,
      "sessionType": sessionType,
      "course": selectedCourse,
    };

    final String? token = await retrieveToken();
    print(token);

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4200/api/student/bid-request'),
        body: jsonEncode(requestData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.statusCode == 200
              ? 'Bidding request created successfully'
              : 'Bidding request creation failed'),
        ),
      );
    } else {
      print('Token not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          100.h.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                Text(
                  'Bidding Request',
                  style: TextStyle(
                    color: AppColor.blueColor,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                40.h.sbh,
                // DropdownButton<String>(
                //   value: selectedCourse,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       selectedCourse = newValue!;
                //     });
                //   },
                //   items: BiddingCourses.courses.map((String course) {
                //     return DropdownMenuItem<String>(
                //       value: course,
                //       child: Text(course),
                //     );
                //   }).toList(),
                // ),
                Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEEEEEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCourse,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCourse = newValue!;
                      });
                    },
                    items: BiddingCourses.courses.map((String course) {
                      return DropdownMenuItem<String>(
                        value: course,
                        child: Text(course),
                      );
                    }).toList(),
                    alignment: Alignment.center,
                  ),
                ),
                15.h.sbh,
                InkWell(
                  onTap: () {
                    setState(() {
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
                    budget = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Budget',
                    border: OutlineInputBorder(),
                  ),
                ),
                15.h.sbh,
                MyButton(
                  text: "Request Bidding",
                  onTap:
                      createBiddingRequest, // Notfication should be sent to the mentor of bid request.
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
