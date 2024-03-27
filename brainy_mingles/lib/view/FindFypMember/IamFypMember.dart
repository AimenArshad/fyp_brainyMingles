import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brainy_mingles/widgets/my_button.dart';
import 'package:brainy_mingles/view/FindFypMember/Screen2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainy_mingles/widgets/custom_appbar.dart';
import 'package:brainy_mingles/widgets/custom_drawer.dart';
import 'package:brainy_mingles/const/sizedbox_extension.dart';
import 'package:brainy_mingles/const/app_colors.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String? cgpa;
  String? department;
  String? idea;

  @override
  void initState() {
    super.initState();
    retrieveSharedData();
  }

  Future<void> retrieveSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cgpa = prefs.getString('cgpa');
      department = prefs.getString('department');
      idea = prefs.getString('idea');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MentorDrawer1(),
      body: Column(
        //  padding: EdgeInsets.all(20.0),
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
                        text: 'Register ',
                        style: TextStyle(
                          color: AppColor.blueColor,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Fyp',
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CGPA',
                    hintText: 'Enter CGPA',
                  ),
                  onChanged: (value) {
                    setState(() {
                      cgpa = value;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Department',
                    hintText: 'Enter Department',
                  ),
                  onChanged: (value) {
                    setState(() {
                      department = value;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Idea',
                    hintText: 'Enter Your Idea',
                  ),
                  onChanged: (value) {
                    setState(() {
                      idea = value;
                    });
                  },
                ),
                SizedBox(height: 20.h),
                MyButton(
                  text: 'Next',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterFyp(
                          cgpa: cgpa,
                          department: department,
                          idea: idea,
                        ),
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
