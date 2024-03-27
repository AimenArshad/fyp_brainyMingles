import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:brainy_mingles/const/app_colors.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/view/FindFypMember/IamFypMember.dart';

class GetYourMember extends StatefulWidget {
  const GetYourMember({Key? key}) : super(key: key);

  @override
  _GetYourMemberState createState() => _GetYourMemberState();
}

class _GetYourMemberState extends State<GetYourMember> {
  List<Map<String, dynamic>> membersData = [];

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
          'http://10.0.2.2:4200/api/student/getfyprecommendations',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          membersData = data.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to load data from the backend');
      }
    } else {
      print('Token not available');
    }
  }

  Future<void> gotMyMembers() async {
    final String? token = await retrieveToken();
    print(token);
    if (token != null) {
      final response = await http.delete(
        Uri.parse(
          'http://10.0.2.2:4200/api/student/got-my-member',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        print('Deleted');
      } else {
        print('Failed to load data from the backend');
      }
    } else {
      print('Token not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StudentDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Fyp ',
                            style: TextStyle(
                              color: AppColor.blueColor,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Members',
                            style: TextStyle(
                              color: const Color(0xFFA0A4A8),
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text(
                                'Did you get the member? Your record will be deleted from recommendations, if yes click ok, otherwise cancel button',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      // Make API call to got-my-member
                                      await gotMyMembers();

                                      // Navigate to Screen1
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Screen1()),
                                      );
                                    } catch (error) {
                                      // Handle any errors
                                      print('Error: $error');
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Error'),
                                          content:
                                              Text('An error occurred: $error'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Got a Member?',
                        style: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                17.h.sbh,
              ],
            ),
          ),
          10.h.sbh,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 17.w, right: 17.w, top: 10.h),
              itemCount: membersData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final membersItem = membersData[index];
                final List<dynamic> skills = membersItem['skills'];
                final List<dynamic> requirements = membersItem['requirements'];

                return GetYourMemberBox(
                  email: membersItem['email'],
                  department: membersItem['department'],
                  cgpa: membersItem['cgpa'],
                  skills: skills,
                  requirements: requirements,
                  idea: membersItem['idea'],
                  fetchDataCallback: fetchDataFromBackend,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GetYourMemberBox extends StatelessWidget {
  final String email;
  final String? department;
  final String? cgpa;
  final List<dynamic> skills;
  final List<dynamic> requirements;
  final String idea;
  final VoidCallback fetchDataCallback;

  GetYourMemberBox({
    required this.email,
    this.department,
    this.cgpa,
    required this.skills,
    required this.requirements,
    required this.idea,
    required this.fetchDataCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Idea: $idea',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Skills:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: skills.map((skill) => Text('• $skill')).toList(),
                  ),
                  SizedBox(height: 8),
                  Text('Requirements:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        requirements.map((req) => Text('• $req')).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
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
                      '$email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (department != null)
                      Text(
                        '$department',
                        style: TextStyle(
                          color: const Color(0xFF3A2F2F),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    if (cgpa != null)
                      Text(
                        'cgpa: $cgpa',
                        style: TextStyle(
                          color: const Color(0xFF3A2F2F),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
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
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
