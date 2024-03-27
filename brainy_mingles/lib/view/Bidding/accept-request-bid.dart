import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainy_mingles/widgets/my_button.dart';

class BiddingRequest extends StatefulWidget {
  const BiddingRequest({Key? key}) : super(key: key);

  @override
  _BiddingRequestState createState() => _BiddingRequestState();
}

class _BiddingRequestState extends State<BiddingRequest> {
  List<dynamic> bidData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchDataFromBackend() async {
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:4200/api/mentor/get-bidding-request',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bidData = data;
        });
      } else {
        print('Failed to load data from the backend');
      }
    } else {
      // Handle the case where the token is not available
      print('Token not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MentorDrawer1(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                17.h.sbh,
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Biddig ',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Requests',
                        style: TextStyle(
                          color: const Color(0xFFA0A4A8),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          10.h.sbh,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 10.h),
              itemCount: bidData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final biddingItem = bidData[index];
                final List<dynamic> bids = biddingItem['bids'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bids.map((bid) {
                    return BiddingRequestBox(
                      studentName: biddingItem['studentName'],
                      studentEmail: biddingItem['studentEmail'],
                      sessionType: bid['sessionType'],
                      budget: bid['budget'],
                      course: bid['course'],
                      fetchDataCallback: fetchDataFromBackend,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BiddingRequestBox extends StatelessWidget {
  final String studentName;
  final String studentEmail;
  final String? sessionType;
  final String? course;
  final String? budget;
  final VoidCallback fetchDataCallback;

  BiddingRequestBox({
    required this.studentName,
    required this.studentEmail,
    this.sessionType,
    this.budget,
    this.course,
    required this.fetchDataCallback,
  });

  Future<void> acceptRequest() async {
    Future<String?> retrieveToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }

    final requestData = {
      "studentEmail": studentEmail,
      "sessionType": sessionType,
      "budget": budget,
      "course": course // Send the student's email
    };
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4200/api/mentor/accept-bidding-request'),
        body: jsonEncode(requestData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // bid request accepted successfully
        print(
            'bid request accepted successfully'); // Notfication should be sent to the student of bid accepted succesfully.
        fetchDataCallback(); // Call the callback to update the data
      } else {
        // Handle the error (e.g., show an error message)
        print('bid request acceptance failed');
      }
    } else {
      // Handle the case where the token is not available
      print('Token not available');
    }
  }

  Future<void> declineRequest() async {
    Future<String?> retrieveToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }

    final requestData = {
      "studentEmail": studentEmail,
      "sessionType": sessionType,
      "budget": budget,
      "course": course // Send the student's email
    };
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4200/api/mentor/reject-bidding-request'),
        body: jsonEncode(requestData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // bid request declined successfully
        print(
            'bid request declined successfully'); // Notfication should be sent to the student of bid request declined.
        fetchDataCallback();
      } else {
        // Handle the error (e.g., show an error message)
        print('bid request decline failed');
      }
    } else {
      print('Token not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 20.h),
      padding:
          EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w, bottom: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.30,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xE88A8888),
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x14323247),
            blurRadius: 32,
            offset: Offset(0, 24),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                width: 70.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: const DecorationImage(
                        image: AssetImage("assets/profile.jpeg"),
                        fit: BoxFit.cover)),
              ),
              13.w.sbw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$studentName',
                    style: TextStyle(
                      color: const Color(0xFF404345),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$studentEmail',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (sessionType != null)
                    Text(
                      'bid Type: $sessionType',
                      style: TextStyle(
                        color: const Color(0xFF3A2F2F),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  Text(
                    'budget: $budget',
                    style: TextStyle(
                      color: const Color(0xFF3A2F2F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'course: $course',
                    style: TextStyle(
                      color: const Color(0xFF3A2F2F),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Image.asset(
                "assets/message.png",
                width: 24.w,
                height: 18.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
          10.h.sbh,
          Row(
            children: [
              MyButton(
                width: 120.w,
                height: 40.h,
                text: "Accept Request",
                textSize: 10.sp,
                onTap: acceptRequest,
              ),
              const Spacer(),
              MyButton(
                width: 120.w,
                height: 40.h,
                text: "Decline Request",
                textSize: 10.sp,
                onTap: declineRequest,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
