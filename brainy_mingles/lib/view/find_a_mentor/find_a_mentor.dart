import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brainy_mingles/view/find_a_mentor/arrange_a_session.dart';
import 'package:brainy_mingles/view/Bidding/bid-a-mentor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_textfield.dart';
import 'package:flutter_svg/svg.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';

class FindAMentorView extends StatefulWidget {
  const FindAMentorView({Key? key});

  @override
  State<FindAMentorView> createState() => _FindAMentorViewState();
}

class _FindAMentorViewState extends State<FindAMentorView> {
  List<dynamic> mentorsData = [];

  @override
  void initState() {
    super.initState();
    fetchMentors();
  }

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('studentId');
  }

  Future<void> fetchMentors() async {
    final String? token = await retrieveToken();
    final String? studentId = await retrieveId();
    print(studentId);
    final response = await http.get(
      //Uri.parse('http://10.0.2.2:4200/api/student/$studentId/displayRecommendations'),
      Uri.parse(
          'http://192.168.10.25:4200/api/student/$studentId/displayRecommendations'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        mentorsData = data['mentors'];
      });
    } else {
      throw Exception('Failed to load mentors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StudentDrawer(),
      // view: const MainHomeViewStudent(),
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
                        text: 'Find ',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'your mentor',
                        style: TextStyle(
                          color: const Color(0xFFA0A4A8),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                10.h.sbh,
                CustomTextField(
                  hint: "Search your mentors etc",
                  borderRadius: BorderRadius.circular(18),
                  suffixIcon: IconButton(
                    onPressed: null,
                    icon: SvgPicture.asset("assets/search_icon.svg"),
                  ),
                ),
              ],
            ),
          ),
          10.h.sbh,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 10.h),
              itemCount: mentorsData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final mentor = mentorsData[index];
                return MentorBox(
                  name: mentor['name'].toString(),
                  email: mentor['email'],
                  gender: mentor['gender'],
                  budget: mentor['budget'].toString(),
                );
              },
            ),
          ),
        ],
      ),
      // Move MainHomeViewStudent to bottomNavigationBar
    );
  }
}

class MentorBox extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final String budget;

  const MentorBox({
    required this.name,
    required this.gender,
    required this.email,
    required this.budget,
    Key? key,
  }) : super(key: key);

  @override
  State<MentorBox> createState() => _MentorBoxState();
}

// class _MentorBoxState extends State<MentorBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.only(bottom: 20.h),
//       padding:
//           EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w, bottom: 12.h),
//       decoration: ShapeDecoration(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(
//             width: 0.30,
//             strokeAlign: BorderSide.strokeAlignOutside,
//             color: Color(0xE88A8888),
//           ),
//           borderRadius: BorderRadius.circular(18),
//         ),
//         shadows: const [
//           BoxShadow(
//             color: Color(0x14323247),
//             blurRadius: 32,
//             offset: Offset(0, 24),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 100.h,
//                 width: 70.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(7),
//                   image: const DecorationImage(
//                     image: AssetImage(
//                         "assets/profile.jpeg"), // Replace with the actual profile picture
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               13.w.sbw,
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.name,
//                     style: TextStyle(
//                       color: const Color(0xFF404345),
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   Text(
//                     widget.email,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   Text(
//                     widget.gender,
//                     style: TextStyle(
//                       color: const Color(0xFF3A2F2F),
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   Text(
//                     widget.budget,
//                     style: TextStyle(
//                       color: const Color(0xFF3A2F2F),
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Image.asset(
//                 "assets/message.png",
//                 width: 24.w,
//                 height: 18.h,
//                 fit: BoxFit.cover,
//               ),
//             ],
//           ),
//           10.h.sbh,
//           Row(
//             children: [
//               MyButton(
//                 width: 120.w,
//                 height: 40.h,
//                 text: "Request a Session",
//                 textSize: 10.sp,
//                 onTap: () {
//                   // Replace 'mentorEmail' with the actual email of the mentor
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ArrangeASessionView(mentorEmail: widget.email),
//                     ),
//                   );
//                 },
//               ),
//               const Spacer(),
//               MyButton(
//                 width: 120.w,
//                 height: 40.h,
//                 text: "Make a bid",
//                 textSize: 10.sp,
//                 onTap: () {
//                   // Replace 'mentorEmail' with the actual email of the mentor
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           BiddingRequestView(mentorEmail: widget.email),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
class _MentorBoxState extends State<MentorBox> {
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _showReportBottomSheet(
      BuildContext context, String username, String email) async {
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
                              final reportData = {
                                "reportedEmail": email,
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
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
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
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                            _showReportBottomSheet(
                                context, widget.name, widget.email);
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
                  height: 100.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: const DecorationImage(
                      image: AssetImage(
                          "assets/profile.jpeg"), // Replace with the actual profile picture
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                13.w.sbw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: const Color(0xFF404345),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.gender,
                      style: TextStyle(
                        color: const Color(0xFF3A2F2F),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.budget,
                      style: TextStyle(
                        color: const Color(0xFF3A2F2F),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.h.sbh,
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
            child: Row(
              children: [
                MyButton(
                  width: 120.w,
                  height: 40.h,
                  text: "Request a Session",
                  textSize: 10.sp,
                  onTap: () {
                    // Replace 'mentorEmail' with the actual email of the mentor
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ArrangeASessionView(mentorEmail: widget.email),
                      ),
                    );
                  },
                ),
                const Spacer(),
                MyButton(
                  width: 120.w,
                  height: 40.h,
                  text: "Make a bid",
                  textSize: 10.sp,
                  onTap: () {
                    // Replace 'mentorEmail' with the actual email of the mentor
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            BiddingRequestView(mentorEmail: widget.email),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
