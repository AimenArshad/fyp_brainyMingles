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
    final response = await http
        .get(Uri.parse('http://10.0.2.2:4200/api/student/$studentId/displayRecommendations'),
        headers: {
          "Authorization": "Bearer $token",
        },);

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
      drawer: const MentorDrawer(),
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
                  gender:mentor['gender'],
                  budget: mentor['budget'].toString(),
                );
              },
            ),
          ),
        ],
      ),
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

class _MentorBoxState extends State<MentorBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
        ],
      ),
    );
  }
}
