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

class SessionRequest extends StatefulWidget {
  const SessionRequest({Key? key}) : super(key: key);

  @override
  _SessionRequestState createState() => _SessionRequestState();
}

class _SessionRequestState extends State<SessionRequest> {
  List<dynamic> sessionData = [];

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
          'http://192.168.10.25:4200/api/mentor/get-session-request',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sessionData = data;
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
                        text: 'Session ',
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
              padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 10.h),
              itemCount: sessionData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final sessionItem = sessionData[index];
                final List<dynamic> sessions = sessionItem['sessions'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sessions.map((session) {
                    return SessionRequestBox(
                      studentName: sessionItem['studentName'],
                      studentEmail: sessionItem['studentEmail'],
                      sessionType: session['sessionType'],
                      time: session['time'],
                      topic: session['topic'],
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

class SessionRequestBox extends StatelessWidget {
  final String studentName;
  final String studentEmail;
  final String? sessionType;
  final String? topic;
  final String? time;
  final VoidCallback fetchDataCallback;

  SessionRequestBox({
    required this.studentName,
    required this.studentEmail,
    this.sessionType,
    this.time,
    this.topic,
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
      "time": time,
      "topic": topic // Send the student's email
    };
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://192.168.10.25:4200/api/mentor/accept-sessionrequest'),
        body: jsonEncode(requestData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Session request accepted successfully');
        fetchDataCallback();
      } else {
        print('Session request acceptance failed');
      }
    } else {
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
      "time": time,
      "topic": topic // Send the student's email
    };
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://192.168.10.25:4200/api/mentor/reject-sessionrequest'),
        body: jsonEncode(requestData),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Session request declined successfully');
        fetchDataCallback();
      } else {
        print('Session request decline failed');
      }
    } else {
      print('Token not available');
    }
  }

  Future<void> _showReportBottomSheet(
      BuildContext context, String username) async {
    String? selectedReason;
    String? customReason;
    String? reason;

    final List<String> reportReasons = [
      'Inappropriate Behavior',
      'Harrasement',
      'Spam',
      'Others'
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Report $username',
                    style: TextStyle(
                      color: AppColor.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    'You are about to report $username. The user wont be notified. You need to provide reason to report a user',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedReason,
                              hint: Text("Select Reason"),
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = value;
                                  reason = selectedReason;
                                });
                              },
                              items: reportReasons.map((reason) {
                                return DropdownMenuItem(
                                  value: reason,
                                  child: Text(reason),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (selectedReason == 'Others')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 18.0),
                        Text(
                          'Enter Reason:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: AppColor.blueColor),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              customReason = value;
                              reason = customReason;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your reason',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedReason != null) {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Report'),
                                  content: Text(
                                      'Are you sure you want to report $username?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        Navigator.of(context).pop(false);

                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        Navigator.of(context).pop(true);

                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm) {
                              Future<String?> retrieveToken() async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                return prefs.getString('token');
                              }

                              final reportData = {
                                "reportedEmail": studentEmail,
                                "reason": reason,
                              };
                              final String? token = await retrieveToken();
                              print(token);
                              if (token != null) {
                                final response = await http.post(
                                  Uri.parse(
                                      'http://192.168.10.25:4200/api/reports/upload-report'),
                                  body: jsonEncode(reportData),
                                  headers: {
                                    "Content-Type": "application/json",
                                    "Authorization": "Bearer $token",
                                  },
                                );

                                if (response.statusCode == 200) {
                                  print('Report made');
                                } else {
                                  print('Couldnt report');
                                }
                              } else {
                                print('Token not available');
                              }
                              Navigator.pop(context); // Close bottom sheet
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please select a reason for reporting.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.blueColor,
                          foregroundColor:
                              Colors.white, // Set the button's background color
                          minimumSize: Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                3.0), // Set the border radius
                          ), // Set the button's minimum size
                        ),
                        child: Text('Report'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.30,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColor.blueColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Icon(Icons.email, color: Colors.white, size: 25),
                SizedBox(width: 10.w),
                PopupMenuButton(
                  icon: Icon(Icons.info_outline, color: Colors.white),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: Icon(Icons.report),
                          title: Text('Report'),
                          onTap: () {
                            _showReportBottomSheet(context, studentName);
                          },
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13.h, left: 15.w, right: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80.h,
                  width: 55.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: const DecorationImage(
                      image: AssetImage("assets/profile.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
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
                          'Session Type: $sessionType',
                          style: TextStyle(
                            color: const Color(0xFF3A2F2F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      Text(
                        'Time: $time',
                        style: TextStyle(
                          color: const Color(0xFF3A2F2F),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Topic: $topic',
                        style: TextStyle(
                          color: const Color(0xFF3A2F2F),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
